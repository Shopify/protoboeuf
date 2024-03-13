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

# Generate a fake value for a field
def gen_fake_field_val(type_map, field)
  field_val = case field.type
  when "bool"
    rand() < 0.5
  when "string"
    # TODO: better random strings with variable lengths
    "foobar" + '_foo' * rand(0..8)
  when "int32", "int64", "uint64", "bool", "sint32", "sint64", "uint32"
    # TODO: we may want a normal or poisson distribution?
    # TODO: do we care about negative integers for this benchmark?
    rand(0..100)
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

  # TODO: enums

  raise "unknown type #{type_name}"
end

# Parse the proto file so we can generate fake data
unit = ProtoBoeuf.parse_file "bench/fixtures/benchmark.proto"

# NOTE: for the benchmark, we can guarantee that we don't have overlapping
# type names, so we can keep a hash of name => definition
type_map = {}
pop_type_map(type_map, unit)

# Generate some fake instances of the root message type
fake_msgs = (0..100).map { |i| gen_fake_data(type_map, 'ParkingLot') }
#p fake_msgs[0]







binary = Upstream::ParkingLot.encode(fake_msgs[0]).freeze

puts "encoded #{binary.size} bytes"

Upstream::ParkingLot.decode binary
ProtoBoeuf::ParkingLot.decode binary






=begin
Benchmark.ips { |x|
  x.report("decode upstream")  { Upstream::ParkingLot.decode binary }
  x.report("decode protoboeuf") { ProtoBoeuf::ParkingLot.decode binary }
  x.compare!
}

Benchmark.ips { |x|
  x.report("decode and read upstream")  { walk Upstream::ParkingLot.decode binary }
  x.report("decode and read protoboeuf") { walk ProtoBoeuf::ParkingLot.decode binary }
  x.compare!
}
=end
