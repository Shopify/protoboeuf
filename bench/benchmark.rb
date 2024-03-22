# frozen_string_literal: true

require "protoboeuf/parser"
require "protoboeuf/benchmark_pb"
require "upstream/benchmark_pb"
require "benchmark/ips"

# Recursively populate the type map
def pop_type_map(type_map, obj)
  if defined? obj.messages
    obj.messages.each do |msg|
      type_map[msg.name] = msg
      pop_type_map(type_map, msg)
    end
  end

  if defined? obj.enums
    obj.enums.each do |enum|
      type_map[enum.name] = enum
      pop_type_map(type_map, enum)
    end
  end
end

@all_non_printable_characters = [
  (127..160), # ascii non_printable
  (0xD800..0xDFFF), # Surrogate pairs
  (0xFDD0..0xFDEF), # noncharacters
  [0xFFFE, 0xFFFF, 0x1FFFE, 0x1FFFF, 0x2FFFE, 0x2FFFF, 0x3FFFE, 0x3FFFF, 0x4FFFE, 0x4FFFF, 0x5FFFE, 0x5FFFF, 0x6FFFE, 0x6FFFF, 0x7FFFE, 0x7FFFF, 0x8FFFE, 0x8FFFF, 0x9FFFE, 0x9FFFF, 0xAFFFE, 0xAFFFF, 0xBFFFE, 0xBFFFF, 0xCFFFE, 0xCFFFF, 0xDFFFE, 0xDFFFF, 0xEFFFE, 0xEFFFF, 0xFFFFE, 0xFFFFF, 0x10FFFE, 0x10FFFF, ], # noncharacters
  (0xE000..0xF8FF), # Private use characters
  (0xF0000..0xFFFFD), # Private use characters
  (0x100000..0x10FFFD), # Private use characters
]

def gen_fake_unicode
  loop do
    # Generate a random index to select a range
    c = rand(32..1114111)

    unless @all_non_printable_characters.find { |r| r.include?(c) }
      return c
    end
  end
end

# Generate a fake value for a field
def gen_fake_field_val(type_map, field)
  case field.type
  when "bool"
    rand < 0.5
  when "bytes"
    (1..rand(255)).map { rand(255).chr("BINARY") }.join
  when "string"
    # TODO: better random strings with variable lengths
    (1..rand(255)).map { gen_fake_unicode }.join
  when "uint32"
    # TODO: we may want a normal or poisson distribution?
    # We don't care about negative integers for this benchmark (rarely used)
    rand(0..(2**32 - 1))
  when "uint64"
    rand(0..(2**64 - 1))
  when "int32", "sint32"
    rand(-(2**31 - 1)..(2**31 - 1))
  when "int64", "sint64"
    rand(-(2**63 - 1)..(2**63 - 1))
  when "float" # float32
    rand.round(7)
  when "double" # float64
    rand
  else
    gen_fake_data(type_map, field.type)
  end
end

# Given a message definition, generate fake data
def gen_fake_msg(type_map, msg_def)
  # Get the message class, e.g. Upstream::ParkingLot
  msg_class = Upstream.const_get(msg_def.name)
  msg = msg_class.new

  # For each field of this message
  msg_def.fields.each do |field|
    if field.repeated?
      arr = (0..20).map { gen_fake_field_val(type_map, field) }
      repeated_field = msg.send("#{field.name}")
      repeated_field.replace(arr)
    elsif field.optional?
      # If optional, randomly set the field or not
      if rand < 0.5
        field_val = gen_fake_field_val(type_map, field)
        msg.send("#{field.name}=", field_val)
      end
    else
      field_val = gen_fake_field_val(type_map, field)
      msg.send("#{field.name}=", field_val)
    end
  end

  msg
end

# Generate a fake enum value
def gen_fake_enum(enum)
  enum.constants.sample.name.to_sym
end

# Given a type name, generate fake data
def gen_fake_data(type_map, type_name)
  # Find the definition for this type
  type_def = type_map[type_name]
  raise "type not found #{type_name}" unless type_def

  if type_def.instance_of?(ProtoBoeuf::Message)
    return gen_fake_msg(type_map, type_def)
  elsif type_def.instance_of?(ProtoBoeuf::Enum)
    return gen_fake_enum(type_def)
  end

  raise "unknown type #{type_name}"
end

# Generate a function to read all fields on every node type
def gen_walk_fn(type_def)
  out = "def walk_#{type_def.name}(node)\n"
  out += "  return unless node\n"

  if type_def.instance_of?(ProtoBoeuf::Message)
    # For each field of this message
    type_def.fields.each do |field|
      if field.repeated?
        out += "  node.#{field.name}.each { |v| walk_#{field.type}(v) }\n"
      else
        case field.type
        when "bool", "string", "bytes", "int32", "sint64", "uint32", "int64", "sint32", "uint64", "float", "double"
          out += "  node.#{field.name}\n"
        else
          out += "  walk_#{field.type}(node.#{field.name})\n"
        end
      end
    end

  elsif type_def.instance_of?(ProtoBoeuf::Enum)
    # Do nothing
  end

  out += "end"

  # puts out

  # Define the function
  eval(out)
end

# Parse the proto file so we can generate fake data
unit = ProtoBoeuf.parse_file("bench/fixtures/benchmark.proto")

# NOTE: for the benchmark, we can guarantee that we don't have overlapping
# type names, so we can keep a hash of name => definition
type_map = {}
pop_type_map(type_map, unit)

# Generate a sum functions for the root type
type_map.each { |type_name, type_def| gen_walk_fn(type_def) }

# Generate some fake instances of the root message type
fake_msgs = (0..10).map { |i| gen_fake_data(type_map, "ParkingLot") }

encoded_bins = fake_msgs.map { |msg| Upstream::ParkingLot.encode(msg).freeze }

bin_sizes = encoded_bins.map { |bin| bin.size }
total_bin_size = bin_sizes.sum
puts "total encoded size: #{total_bin_size} bytes"

Benchmark.ips do |x|
  x.report("decode upstream") { encoded_bins.each { |bin| Upstream::ParkingLot.decode(bin) } }
  x.report("decode protoboeuf") { encoded_bins.each { |bin| ProtoBoeuf::ParkingLot.decode(bin) } }
  x.compare!
end

Benchmark.ips do |x|
  x.report("decode and read upstream") { encoded_bins.each { |bin| walk_ParkingLot(Upstream::ParkingLot.decode(bin)) } }
  x.report("decode and read protoboeuf") do
    encoded_bins.each do |bin|
      walk_ParkingLot(ProtoBoeuf::ParkingLot.decode(bin))
    end
  end
  x.compare!
end
