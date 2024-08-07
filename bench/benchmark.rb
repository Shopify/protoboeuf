# frozen_string_literal: true

require "protoboeuf/parser"
require "protoboeuf/benchmark_pb"
require "upstream/benchmark_pb"
require "benchmark/ips"

# Ensure the dataset is random but always the same
Random.srand(42)

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

# Generate a fake value for a field
def gen_fake_field_val(type_map, field)
  case field.type
  when "bool"
    rand() < 0.5
  when "string"
    # TODO: better random strings with variable lengths
    "foobar" + '_foo' * rand(0..8)
  when "int32", "int64", "uint64", "bool", "sint32", "sint64", "uint32"
    # TODO: we may want a normal or poisson distribution?
    # We don't care about negative integers for this benchmark (rarely used)
    rand(0..300)
  when "float", "double"
    rand() * 100.0
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
      if rand() < 0.5
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

  if type_def.instance_of? ProtoBoeuf::Message
    return gen_fake_msg(type_map, type_def)
  elsif type_def.instance_of? ProtoBoeuf::Enum
    return gen_fake_enum(type_def)
  end

  raise "unknown type #{type_name}"
end

# Generate a function to read all fields on every node type
def gen_walk_fn(type_def)

  out = "def walk_#{type_def.name}(node)\n"
  out += "  return unless node\n"

  if type_def.instance_of? ProtoBoeuf::Message
    # For each field of this message
    type_def.fields.each do |field|
      if field.repeated?
        out += "  node.#{field.name}.each { |v| walk_#{field.type}(v) }\n"
      else
        case field.type
        when "bool", "string", "int32", "int64", "uint64", "bool", "sint32", "sint64", "uint32", "float", "double"
          out += "  node.#{field.name}\n"
        else
          out += "  walk_#{field.type}(node.#{field.name})\n"
        end
      end
    end

  elsif type_def.instance_of? ProtoBoeuf::Enum
    # Do nothing
  end

  out += "end"

  #puts out

  # Define the function
  eval(out)
end

# Parse the proto file so we can generate fake data
unit = ProtoBoeuf.parse_file "bench/fixtures/benchmark.proto"

# NOTE: for the benchmark, we can guarantee that we don't have overlapping
# type names, so we can keep a hash of name => definition
type_map = {}
pop_type_map(type_map, unit)

# Generate a sum functions for the root type
type_map.each { |type_name, type_def| gen_walk_fn(type_def) }

# Generate some fake instances of the root message type
fake_msgs = (0..10).map { |i| gen_fake_data(type_map, 'ParkingLot') }

encoded_bins = fake_msgs.map { |msg| Upstream::ParkingLot.encode(msg).freeze }

bin_sizes = encoded_bins.map { |bin| bin.size }
total_bin_size = bin_sizes.sum
puts "total encoded size: #{total_bin_size} bytes"

# Decode the messages using protoboeuf so we can re-encode them for the encoding benchmark
# We do this because ProtoBoeuf can't directly encode Google's protobuf message classes
decoded_msgs_proto = encoded_bins.map { |bin| ProtoBoeuf::ParkingLot.decode bin }

version = RubyVM::YJIT.enabled? ? "/jit" : "/interp"

puts "=== decode ==="
Benchmark.ips do |x|
  x.report("upstream#{version}")  { encoded_bins.each { |bin| Upstream::ParkingLot.decode bin } }
  x.report("protoboeuf#{version}") { encoded_bins.each { |bin| ProtoBoeuf::ParkingLot.decode bin } }

  x.save!(File.join(ENV["BENCH_HOLD"], "decode.bench")) if ENV["BENCH_HOLD"]
  x.compare!(order: :baseline)
end

puts "=== decode and read ==="
Benchmark.ips do |x|
  x.report("upstream#{version}")  { encoded_bins.each { |bin| walk_ParkingLot(Upstream::ParkingLot.decode bin) } }
  x.report("protoboeuf#{version}") { encoded_bins.each { |bin| walk_ParkingLot(ProtoBoeuf::ParkingLot.decode bin) } }

  x.save!(File.join(ENV["BENCH_HOLD"], "read.bench")) if ENV["BENCH_HOLD"]
  x.compare!(order: :baseline)
end

puts "=== encode ==="
Benchmark.ips do |x|
  x.report("upstream#{version}")  { fake_msgs.each { |msg| Upstream::ParkingLot.encode(msg) } }
  x.report("protoboeuf#{version}") { decoded_msgs_proto.each { |msg| ProtoBoeuf::ParkingLot.encode(msg) } }

  x.save!(File.join(ENV["BENCH_HOLD"], "encode.bench")) if ENV["BENCH_HOLD"]
  x.compare!(order: :baseline)
end
