require "helper"
require "protoboeuf/protobuf/uint64value"

class WellKnownTypesTest < ProtoBoeuf::Test
  def test_field_mask
    unit = parse_string(<<-EOPROTO)
syntax = "proto3";

message Foo {
  google.protobuf.FieldMask mask = 1;
}
    EOPROTO

    gen = ProtoBoeuf::CodeGen.new unit
    klass = Class.new { self.class_eval gen.to_ruby }

    foo = klass::Foo.new
    foo.mask = ProtoBoeuf::Protobuf::FieldMask.new
    foo.mask.paths << "hi"

    foo = klass::Foo.decode klass::Foo.encode foo
    assert_equal ["hi"], foo.mask.paths
  end

  def test_duration
    unit = parse_string(<<-EOPROTO)
syntax = "proto3";

message Foo {
  google.protobuf.Duration time = 1;
}
    EOPROTO

    gen = ProtoBoeuf::CodeGen.new unit
    klass = Class.new { self.class_eval gen.to_ruby }

    foo = klass::Foo.new
    foo.time = ProtoBoeuf::Protobuf::Duration.new
    assert_equal 0, foo.time.seconds
    assert_equal 0, foo.time.nanos

    foo.time.seconds = 123456
    foo.time.nanos = 10

    foo = klass::Foo.decode klass::Foo.encode foo
    assert_equal 123456, foo.time.seconds
    assert_equal 10, foo.time.nanos
  end

  def test_uint64
    v = ProtoBoeuf::Protobuf::UInt64Value.new
    assert_equal 0, v.value
  end

  def test_uint64_decode
    data = Google::Protobuf::UInt64Value.encode(Google::Protobuf::UInt64Value.new.tap { |x|
      x.value = 1234
    })
    v = ProtoBoeuf::Protobuf::UInt64Value.decode data
    assert_equal 1234, v.value
  end

  def test_struct
    unit = parse_string(<<-EOPROTO)
syntax = "proto3";
message Foo {
  google.protobuf.Struct struct_value = 1;
  google.protobuf.Value value = 2;
  google.protobuf.ListValue list_value = 3;
}
    EOPROTO

    gen = ProtoBoeuf::CodeGen.new unit
    klass = Class.new { self.class_eval gen.to_ruby }

    foo = klass::Foo.new.tap do |x|
      x.value = ProtoBoeuf::Protobuf::Value.new(string_value: "one")
      x.list_value = ProtoBoeuf::Protobuf::ListValue.new.tap do |v|
        v.values = %w[two three].map do |s|
          ProtoBoeuf::Protobuf::Value.new(string_value: s)
        end
      end
      x.struct_value = ProtoBoeuf::Protobuf::Struct.new(fields: {
        "key" => ProtoBoeuf::Protobuf::Value.new(string_value: "f1"),
        "value" => ProtoBoeuf::Protobuf::Value.new(string_value: "f2"),
      })
    end

    foo = klass::Foo.decode klass::Foo.encode foo
    assert_equal("one", foo.value.string_value)
    assert_equal(%w[two three], foo.list_value.values.map(&:string_value))
    assert_equal({"key" => "f1", "value" => "f2"}, foo.struct_value.fields.map { |k,v| [k, v.string_value] }.to_h)
  end

  private

  def parse_string(string)
    ProtoBoeuf.parse_string string
  end
end
