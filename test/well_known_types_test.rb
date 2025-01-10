# frozen_string_literal: true

require "helper"
require "protoboeuf/google/protobuf/descriptor"
require "protoboeuf/google/protobuf/uint64value"

class WellKnownTypesTest < ProtoBoeuf::Test
  def test_any
    unit = parse_proto_string(<<~EOPROTO)
      syntax = "proto3";

      import "google/protobuf/any.proto";

      message Foo {
        google.protobuf.Any any = 1;
      }
    EOPROTO

    gen = ProtoBoeuf::CodeGen.new(unit)
    klass = Class.new { class_eval(gen.to_ruby) }

    foo = klass::Foo.new
    foo.any = ::ProtoBoeuf::Google::Protobuf::Any.new(
      type_url: "url",
      value: "val",
    )

    foo = klass::Foo.decode(klass::Foo.encode(foo))
    assert_equal("url", foo.any.type_url)
    assert_equal("val", foo.any.value)
  end

  def test_field_mask
    unit = parse_proto_string(<<~EOPROTO)
      syntax = "proto3";

      import "google/protobuf/field_mask.proto";

      message Foo {
        google.protobuf.FieldMask mask = 1;
      }
    EOPROTO

    gen = ProtoBoeuf::CodeGen.new(unit)
    klass = Class.new { class_eval(gen.to_ruby) }

    foo = klass::Foo.new
    foo.mask = ::ProtoBoeuf::Google::Protobuf::FieldMask.new
    foo.mask.paths << "hi"

    foo = klass::Foo.decode(klass::Foo.encode(foo))
    assert_equal(["hi"], foo.mask.paths)
  end

  def test_duration
    unit = parse_proto_string(<<~EOPROTO)
      syntax = "proto3";

      import "google/protobuf/duration.proto";

      message Foo {
        google.protobuf.Duration time = 1;
      }
    EOPROTO

    gen = ProtoBoeuf::CodeGen.new(unit)
    klass = Class.new { class_eval(gen.to_ruby) }

    foo = klass::Foo.new
    foo.time = ::ProtoBoeuf::Google::Protobuf::Duration.new
    assert_equal(0, foo.time.seconds)
    assert_equal(0, foo.time.nanos)

    foo.time.seconds = 123456
    foo.time.nanos = 10

    foo = klass::Foo.decode(klass::Foo.encode(foo))
    assert_equal(123456, foo.time.seconds)
    assert_equal(10, foo.time.nanos)
  end

  def test_descriptor
    fd = ::ProtoBoeuf::Google::Protobuf::FileDescriptorProto.new(
      name: "n",
      edition: :EDITION_2023,
    )

    assert_predicate(fd, :has_name?, "optional field predicate should be true when initialized")
    refute_predicate(fd, :has_package?, "optional field predicate should be false when not initialized")

    assert_equal(fd.edition, :EDITION_2023, "enum resolve")
    # Test that the resolve/lookup is working and that we aren't just passing through.
    assert_equal(1000, fd.instance_variable_get(:@edition), "enum lookup")
  end

  def test_uint64
    v = ::ProtoBoeuf::Google::Protobuf::UInt64Value.new
    assert_equal(0, v.value)
  end

  def test_uint64_decode
    data = ::Google::Protobuf::UInt64Value.encode(::Google::Protobuf::UInt64Value.new.tap do |x|
      x.value = 1234
    end)
    v = ::ProtoBoeuf::Google::Protobuf::UInt64Value.decode(data)
    assert_equal(1234, v.value)
  end

  def test_null
    unit = parse_proto_string(<<~EOPROTO)
      syntax = "proto3";

      import "google/protobuf/struct.proto";

      message Foo {
        google.protobuf.NullValue null = 1;
      }
    EOPROTO

    gen = ProtoBoeuf::CodeGen.new(unit)
    klass = Class.new { class_eval(gen.to_ruby) }

    assert_equal(:NULL_VALUE, klass::Foo.new.null)
  end

  def test_struct
    unit = parse_proto_string(<<~EOPROTO)
      syntax = "proto3";

      import "google/protobuf/struct.proto";

      message Foo {
        google.protobuf.Struct struct_value = 1;
        google.protobuf.Value value = 2;
        google.protobuf.ListValue list_value = 3;
      }
    EOPROTO

    gen = ProtoBoeuf::CodeGen.new(unit)
    klass = Class.new { class_eval(gen.to_ruby) }

    foo = klass::Foo.new.tap do |x|
      x.value = ::ProtoBoeuf::Google::Protobuf::Value.new(string_value: "one")
      x.list_value = ::ProtoBoeuf::Google::Protobuf::ListValue.new.tap do |v|
        v.values = ["two", "three"].map do |s|
          ::ProtoBoeuf::Google::Protobuf::Value.new(string_value: s)
        end
      end
      x.struct_value = ::ProtoBoeuf::Google::Protobuf::Struct.new(fields: {
        "key" => ::ProtoBoeuf::Google::Protobuf::Value.new(string_value: "f1"),
        "value" => ::ProtoBoeuf::Google::Protobuf::Value.new(string_value: "f2"),
      })
    end

    foo = klass::Foo.decode(klass::Foo.encode(foo))
    assert_equal("one", foo.value.string_value)
    assert_equal(["two", "three"], foo.list_value.values.map(&:string_value))
    assert_equal({ "key" => "f1", "value" => "f2" }, foo.struct_value.fields.map { |k, v| [k, v.string_value] }.to_h)
  end

  def test_field_behavior
    unit = parse_proto_string(<<~EOPROTO)
      syntax = "proto3";

      import "google/api/field_behavior.proto";

      message HasRequiredField {
        bool a_boolean = 1 [(google.api.field_behavior) = REQUIRED];
      }
    EOPROTO

    gen = ProtoBoeuf::CodeGen.new(unit)
    klass = Class.new { class_eval(gen.to_ruby) }

    has_required_field = klass::HasRequiredField.new.tap do |x|
      x.a_boolean = true
    end

    assert_predicate(has_required_field, :a_boolean)
  end
end
