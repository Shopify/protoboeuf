# frozen_string_literal: true

require "helper"
require "tempfile"
require "google/protobuf/descriptor_pb"
require_relative "fixtures/package_test_pb.rb"

module ProtoBoeuf
  # Allow CI to default the append_as_bytes option to false.
  class CodeGen
    prepend(Module.new do
      def to_ruby(this_file = nil, options = { append_as_bytes: !ENV["NO_APPEND_AS_BYTES"] })
        super
      end
    end)
  end

  class CodeGenTest < Test
    def test_enum_with_underscore
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message Vehicle
        {
          enum VEHICLE_TYPE {
            CAR = 0;
            SPORTS_CAR = 1;
          }

          VEHICLE_TYPE type = 6;
        }
      EOPROTO

      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::Vehicle.new
      assert_equal(:CAR, msg.type)
      msg.type = :SPORTS_CAR
      assert_equal(:SPORTS_CAR, msg.type)
    end

    def test_too_many_fields_multiple
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message TooManyFieldsAgain {
          uint32 a = 31;
          uint32 b = 36;
        }
      EOPROTO
      gen = CodeGen.new(unit)

      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::TooManyFieldsAgain.new(a: 0xFF, b: 456)
      data = klass::TooManyFieldsAgain.encode(msg)

      assert_equal(::TooManyFieldsAgain.encode(::TooManyFieldsAgain.new(a: 0xFF, b: 456)), data)

      msg = klass::TooManyFieldsAgain.decode(data)
      assert_equal(0xFF, msg.a)
      assert_equal(456, msg.b)
    end

    def test_too_many_fields
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message TooManyFields {
          uint32 a = 32;
        }
      EOPROTO
      gen = CodeGen.new(unit)

      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::TooManyFields.new(a: 123)
      data = klass::TooManyFields.encode(msg)
      assert_equal(::TooManyFields.encode(::TooManyFields.new(a: 123)), data)

      msg = klass::TooManyFields.decode(data)
      assert_equal(123, msg.a)
    end

    def test_uppercase_field_name
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message Foo {
          uint64 FieldName = 1;
        }
      EOPROTO

      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      foo = klass::Foo.new
      assert_equal(0, foo.FieldName)
      foo.FieldName = 1

      foo = klass::Foo.decode(klass::Foo.encode(foo))
      assert_equal(1, foo.FieldName)
    end

    def test_map_complex_types
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message Foo {
          message Bar {
            string test = 1;
          }

          map<string, Bar> attributes = 5;
        }
      EOPROTO

      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      foo = klass::Foo.new
      foo.attributes["bar"] = klass::Foo::Bar.new
      foo.attributes["bar"].test = "hello"

      foo = klass::Foo.decode(klass::Foo.encode(foo))
      assert_equal("hello", foo.attributes["bar"].test)
    end

    def test_decode_embedder
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message TestEmbeddee {
          uint64 value = 1;
        }

        message TestEmbedder {
          // Comment between fields
          TestEmbeddee value = 2;
          string message = 3;
        }
      EOPROTO

      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      data = klass::TestEmbedder.encode(klass::TestEmbedder.new.tap do |x|
        x.value = klass::TestEmbeddee.new(value: 5678)
        x.message = "hello world"
      end)

      obj = klass::TestEmbedder.decode(data)
      assert_equal(5678, obj.value.value)
      assert_equal("hello world", obj.message)
    end

    def test_decode_repeated_unpacked
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message UnpackedFields {
          uint32 a = 1;
          repeated uint32 ids = 2 [packed = false];
          int64 b = 3;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::UnpackedFields.new(a: 123, ids: [1, 2, 0xFF, 0xFF], b: 0xCAFE)

      data = ::UnpackedFields.encode(::UnpackedFields.new.tap do |x|
        x.a = 123
        x.ids[0] = 1
        x.ids[1] = 2
        x.ids[2] = 0xFF
        x.ids[3] = 0xFF
        x.b = 0xCAFE
      end)

      assert_equal(data.bytes, klass::UnpackedFields.encode(msg).bytes)
    end

    def test_decode_repeated
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message TestRepeatedField {
          repeated uint32 e = 1;
          int64 another_value = 2;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::TestRepeatedField.new(e: [1, 2, 0xFF, 0xFF], another_value: 0xCAFE)

      data = ::TestRepeatedField.encode(::TestRepeatedField.new.tap do |x|
        x.e[0] = 1
        x.e[1] = 2
        x.e[2] = 0xFF
        x.e[3] = 0xFF
        x.another_value = 0xCAFE
      end)

      assert_equal(data.bytes, klass::TestRepeatedField.encode(msg).bytes)
    end

    def test_oneof_decoding
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message TestMessageWithOneOf {
          oneof oneof_field {
            string oneof_str = 7;
          }
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::TestMessageWithOneOf.new(oneof_str: "hello")
      klass::TestMessageWithOneOf.decode(klass::TestMessageWithOneOf.encode(msg))
    end

    def test_optional_fields
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message ManyOptional {
          optional uint64 b = 2;
          uint64 c = 3;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      assert(Class.new { class_eval(gen.to_ruby) })
    end

    def test_many_optional_fields
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message TestManyOptionalFields {
          #{(1..99).map { |i| "optional int32 a#{i} = #{i};" }.join("\n")}
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::TestManyOptionalFields.new(a59: 0, a60: 1, a99: 1)
      msg = klass::TestManyOptionalFields.decode(klass::TestManyOptionalFields.encode(msg))
      refute_predicate(msg, :has_a59?)
      assert_predicate(msg, :has_a60?)
      assert_predicate(msg, :has_a99?)
    end

    def test_enum_field
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        enum TestEnum {
          FOO = 0;
          BAR = 1;
          BAZ = 2;
        }

        message Test1 {
          TestEnum enum_1 = 1;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::Test1.new
      assert_equal(:FOO, msg.enum_1)
      msg.enum_1 = :BAR

      msg = klass::Test1.decode(klass::Test1.encode(msg))
      assert_equal(:BAR, msg.enum_1)
    end

    def test_neg_enum
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        enum TestEnum {
          FOO = 0;
          BAR = 1;
          BAZ = -1;
        }

        message Test1 {
          TestEnum enum_1 = 1;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::Test1.new(enum_1: :BAZ)
      msg = klass::Test1.decode(klass::Test1.encode(msg))
      assert_equal(:BAZ, msg.enum_1)
    end

    def test_optional_enum
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        enum TestEnum {
          FOO = 0;
          BAR = 1;
        }

        message Test1 {
          optional TestEnum enum_1 = 1;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::Test1.new(enum_1: :BAR)
      msg = klass::Test1.decode(msg.to_proto)
      assert_equal(:BAR, msg.enum_1)

      msg.enum_1 = :FOO
      msg = klass::Test1.decode(msg.to_proto)
      assert_equal(:FOO, msg.enum_1)
    end

    def test_required_field
      unit = parse_string(<<~EOPROTO)
        message Test1 {
          required uint32 u32 = 1;
          optional int32 i32 = 2;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::Test1.new
      msg.u32 = 1234
      msg.i32 = 1234

      msg = klass::Test1.decode(klass::Test1.encode(msg))
      assert_equal(1234, msg.u32)
      assert_equal(1234, msg.i32)
    end

    def test_map_fields
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message Test1 {
          map<string, int32> map_field = 1;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::Test1.new
      assert_equal({}, msg.map_field)

      msg.map_field["foo"] = 1234

      msg = klass::Test1.decode(klass::Test1.encode(msg))
      assert_equal({ "foo" => 1234 }, msg.map_field)
    end

    def test_oneof
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";

        message TestEmbeddee {
          uint64 value = 1;
        }

        message TestMessageWithOneOf {
          string id = 1;
          uint64 shop_id = 2;

          oneof oneof_field {
            uint32 oneof_u32 = 5;
            TestEmbeddee oneof_msg = 6;
            string oneof_str = 7;
          }

          bool boolean = 3;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::TestMessageWithOneOf.new
      assert_equal(0, msg.oneof_u32)
      assert_nil(msg.oneof_msg)
      assert_equal("", msg.oneof_str)
      assert_nil(msg.oneof_field)

      msg.oneof_str = "hello"
      assert_equal("hello", msg.oneof_str)
      assert_equal(:oneof_str, msg.oneof_field)

      msg.oneof_u32 = 123
      assert_equal(123, msg.oneof_u32)
      assert_equal(:oneof_u32, msg.oneof_field)
    end

    def test_decode_no_fields
      unit = parse_string('syntax = "proto3"; message NoFields { }')
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval gen.to_ruby }
      obj = klass::NoFields.decode("")
      assert_kind_of(klass::NoFields, obj)
    end

    def test_decode_empty_many_fields
      # Use field number high enough to require looking for second varint byte.
      unit = parse_string('syntax = "proto3"; message DecodeEmpty { string a = 16; }')
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval gen.to_ruby }
      encoded = klass::DecodeEmpty.new.to_proto
      assert_equal("", encoded)
      obj = klass::DecodeEmpty.decode(encoded)
      assert_equal("", obj.a)
    end

    def test_make_ruby
      unit = parse_string(
        'syntax = "proto3"; message TestMessage { string id = 1; uint64 shop_id = 2; bool boolean = 3; }',
      )
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }
      obj = klass::TestMessage.new
      assert_equal("", obj.id)
      assert_equal(0, obj.shop_id)
      assert_equal(false, obj.boolean)
    end

    def test_int32
      unit = parse_string('syntax = "proto3"; message Test1 { optional int32 a = 1; }')
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }
      obj = klass::Test1.new
      assert_equal(0, obj.a)
    end

    def test_oneof_edition_2023
      skip("Editions not supported by parser") if protoboeuf_parser?

      unit = parse_string(<<~EOPROTO)
        edition = "2023";

        message TestMessageWithOneOf {
          oneof oneof_field {
            string oneof_str = 1;
          }
          string after_oneof = 2;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::TestMessageWithOneOf.new(oneof_str: "hello")
      assert_predicate(msg, :has_oneof_str?)
      obj = klass::TestMessageWithOneOf.decode(klass::TestMessageWithOneOf.encode(msg))
      assert_predicate(obj, :has_oneof_str?)

      assert_equal(
        { oneof_str: "hello", after_oneof: "" },
        obj.to_h,
        "to_h should contain all fields",
      )
    end

    # One of our well known types (descriptor.proto) has proto2 syntax so we want to test our codegen of it.
    def test_optional_predicate_proto2
      skip("Syntax proto2 not supported by parser") if protoboeuf_parser?

      unit = parse_string(<<~EOPROTO)
        syntax = "proto2";

        message TestMessageWithOptional {
          optional string s = 2;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }

      msg = klass::TestMessageWithOptional.new(s: "hello")
      assert_predicate(msg, :has_s?)
      obj = klass::TestMessageWithOptional.decode(msg.to_proto)
      assert_predicate(obj, :has_s?)
    end

    def test_fixture_file
      unit = parse_file("./test/fixtures/test.proto")

      gen = CodeGen.new(unit)

      klass = Class.new { class_eval(gen.to_ruby) }
      obj = klass::Test1.new
      assert_equal(0, obj.a)

      assert_equal([], klass::TestRepeatedField.new.e)
    end

    def test_fields_keyword_end
      unit = parse_string('syntax = "proto3"; message Test1 { optional int32 end = 1; }')
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }
      obj = klass::Test1.new(end: 1234)
      assert_equal(1234, obj.end)
    end

    def test_fields_keyword_class
      unit = parse_string('syntax = "proto3"; message Test1 { optional int32 class = 1; }')
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }
      obj = klass::Test1.new(class: 1234)
      assert_equal(1234, obj.class)
    end

    def test_fields_keyword_nil
      unit = parse_string('syntax = "proto3"; message Test1 { optional int32 nil = 1; }')
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }
      obj = klass::Test1.new(nil: 1234)
      assert_equal(1234, obj.nil)
    end

    def test_repeated
      unit = parse_string('syntax = "proto3"; message Test1 { repeated int32 repeated_ints = 1; }')
      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }
      obj = klass::Test1.new
      assert_equal([], obj.repeated_ints)
      obj.repeated_ints << 123

      obj = klass::Test1.decode(klass::Test1.encode(obj))
      assert_equal([123], obj.repeated_ints)
    end

    def test_generate_types
      proto = File.read("test/fixtures/typed_test.proto")
      unit = parse_string(proto)

      gen = CodeGen.new(unit, generate_types: true)

      File.write("test/fixtures/typed_test.generated.rb", gen.to_ruby)

      # The goal of this test is to ensure that we generate valid sorbet signatures.
      #
      # This tests will break whenever any implementation of field encoding/deconding etc changes.
      # While this is not great, writing tests that ensure that signatures are generated
      # correctly without pulling in all of sorbet is at the very least incredibly complex.
      # So this is the solution for now.
      assert_equal(File.read("test/fixtures/typed_test.correct.rb"), gen.to_ruby)
    end

    def test_modules_with_package
      unit = parse_string(<<~PROTO)
        package example.code_gen.package;

        message Foo {}
      PROTO

      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }
      assert(klass::Example::CodeGen::Package::Foo.new)
    end

    def test_modules_with_ruby_package
      unit = parse_string(<<~PROTO)
        package example.proto;

        option ruby_package = "Example::Ruby::Package";

        message Foo {}
      PROTO

      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }
      assert(klass::Example::Ruby::Package::Foo.new)
    end

    def test_type_name_to_class_name
      unit = parse_string(<<~PROTO)
        package example_foo.proto;
        import "package_test.proto";

        message Foo {
          required package_test.proto3.Test1 t = 1;
        }
      PROTO

      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }
      msg = klass::ExampleFoo::Proto::Foo.new(
        # Just put anything so that the "t" field goes through the encode/decode.
        t: Object.new.tap { |o| def o._encode(*); end },
      )

      # ProtoBoeuf expects decode_from but the protoc version won't define that method.
      # We just want to test that there are no other errors from the class we
      # just generated so make this a no-op.
      unless PackageTest::Proto3::Test1.instance_methods.include?(:decode_from)
        PackageTest::Proto3::Test1.define_method(:decode_from) { |*| :ok }
      end

      assert(klass::ExampleFoo::Proto::Foo.decode(
        klass::ExampleFoo::Proto::Foo.encode(msg),
      ))
    end

    def test_requires
      skip("no implicit well known type for protoc tests") unless protoboeuf_parser?

      unit = parse_string(<<~PROTO)
        package example.proto;

        message Foo {
          optional google.protobuf.StringValue s = 1;
        }
      PROTO

      gen = CodeGen.new(unit)
      path = "protoboeuf/protobuf/stringvalue"
      require_line = /require ['"]#{path}['"]/
      assert(ruby_script_header(gen.to_ruby.to_s).match?(require_line), "require should be in header")
      refute(gen.to_ruby(path).to_s.match?(require_line), "require should not be present")
    end

    def test_to_proto
      unit = parse_string(<<~PROTO)
        syntax = "proto3";

        message Foo {
          int32 a = 1;
        }
      PROTO

      gen = CodeGen.new(unit)
      klass = Class.new { class_eval gen.to_ruby }
      obj = klass::Foo.new(a: 255)

      assert_equal(255, obj.a)
      assert_equal("\x08\xff\x01".b, obj.to_proto)
    end

    def test_unknown_fields
      unit = parse_string(<<~EOPROTO)
        syntax = "proto3";
        message M1 {
          string a = 1;
          bool   bool = 2;
          uint64 uint64 = 3;
          sint64 sint64 = 4;
          double i64 = 5;
          float i32 = 6;
          string str = 7;
        }
      EOPROTO
      gen = CodeGen.new(unit)
      more = Class.new { class_eval gen.to_ruby }

      attr = { a: "A", bool: true, uint64: (1 << 57), sint64: -2**63, i64: 2.5, i32: 1.25, str: "str" }
      msg = more::M1.new(**attr).to_proto
      assert_equal(attr, more::M1.decode(msg).to_h)

      # Include a gap in field numbers so that we test finding a field after discarding some.
      unit = parse_string('syntax = "proto3"; message M2 { string a = 1; sint64 sint64 = 4; }')
      gen = CodeGen.new(unit)
      less = Class.new { class_eval gen.to_ruby }

      m2_decoded = less::M2.decode(msg)
      assert_equal({ a: "A", sint64: -2**63 }, m2_decoded.to_h)
    end

    def test_high_field_number
      max_field = 2**29 - 1
      unit = parse_string(%(syntax = "proto3"; message Max { int32 a = #{max_field}; }))
      gen = CodeGen.new(unit)
      max_class = Class.new { class_eval gen.to_ruby }

      msg = max_class::Max.new(a: 1).to_proto
      assert_equal(1, max_class::Max.decode(msg).a, "expected field #{max_field} to populate")

      # Use high enough field number to be a multi-byte varint.
      small_field = 0x10 << 3
      unit = parse_string(%(syntax = "proto3"; message Small { int32 a = #{small_field}; }))
      gen = CodeGen.new(unit)
      small_class = Class.new { class_eval gen.to_ruby }

      msg += small_class::Small.new(a: 1).to_proto

      assert_equal(1, small_class::Small.decode(msg).a, "expected field #{small_field} to populate")

      # Also test message with only low field numbers.
      unit = parse_string(%(syntax = "proto3"; message One { int32 a = 1; }))
      gen = CodeGen.new(unit)
      one_class = Class.new { class_eval gen.to_ruby }

      msg += one_class::One.new(a: 1).to_proto

      assert_equal(1, one_class::One.decode(msg).a, "expected field 1 to populate")
    end

    def test_bounds_checks
      proto = <<~PROTO
        message Test1 {
          optional int32 i32 = 1;
          optional sint32 s32 = 2;
          required uint32 u32 = 3;
          required int64 i64 = 4;
          required sint64 s64 = 5;
          optional uint64 u64 = 6;
          repeated int32 i32s = 7;
          repeated sint32 s32s = 8;
          repeated uint32 u32s = 9;
          repeated int64 i64s = 10;
          repeated sint64 s64s = 11;
          repeated uint64 u64s = 12;
        }
      PROTO
      unit = parse_string(proto)

      gen = CodeGen.new(unit)
      klass = Class.new { class_eval(gen.to_ruby) }
      obj = klass::Test1.new

      assert_raises(RangeError) do
        obj.i32 = -2_147_483_649
      end
      obj.i32 = -2_147_483_648
      obj.i32 = 2_147_483_647
      assert_raises(RangeError) do
        obj.i32 = 2_147_483_648
      end

      assert_raises(RangeError) do
        obj.s32 = -2_147_483_649
      end
      obj.s32 = -2_147_483_648
      obj.s32 = 2_147_483_647
      assert_raises(RangeError) do
        obj.s32 = 2_147_483_648
      end

      assert_raises(RangeError) do
        obj.u32 = -1
      end
      obj.u32 = 0
      obj.u32 = 4_294_967_295
      assert_raises(RangeError) do
        obj.u32 = 4_294_967_296
      end

      assert_raises(RangeError) do
        obj.i64 = -9_223_372_036_854_775_809
      end
      obj.i64 = -9_223_372_036_854_775_808
      obj.i64 = 9_223_372_036_854_775_807
      assert_raises(RangeError) do
        obj.i64 = 9_223_372_036_854_775_808
      end

      assert_raises(RangeError) do
        obj.s64 = -9_223_372_036_854_775_809
      end
      obj.s64 = -9_223_372_036_854_775_808
      obj.s64 = 9_223_372_036_854_775_807
      assert_raises(RangeError) do
        obj.s64 = 9_223_372_036_854_775_808
      end

      assert_raises(RangeError) do
        obj.u64 = -1
      end
      obj.u64 = 0
      obj.u64 = 18_446_744_073_709_551_615
      assert_raises(RangeError) do
        obj.u64 = 18_446_744_073_709_551_616
      end

      assert_raises(RangeError) do
        obj.i32s = [-2_147_483_649, -2_147_483_648, 2_147_483_647]
      end
      obj.i32s = [-2_147_483_648, 2_147_483_647]
      assert_raises(RangeError) do
        obj.i32s = [-2_147_483_648, 2_147_483_647, 2_147_483_648]
      end

      assert_raises(RangeError) do
        obj.s32s = [-2_147_483_649, -2_147_483_648, 2_147_483_647]
      end
      obj.s32s = [-2_147_483_648, 2_147_483_647]
      assert_raises(RangeError) do
        obj.s32s = [-2_147_483_648, 2_147_483_647, 2_147_483_648]
      end

      assert_raises(RangeError) do
        obj.u32s = [-1, 0, 2_147_483_647]
      end
      obj.u32s = [0, 4_294_967_295]
      assert_raises(RangeError) do
        obj.u32s = [0, 4_294_967_295, 4_294_967_296]
      end

      assert_raises(RangeError) do
        obj.i64s = [-9_223_372_036_854_775_809, -9_223_372_036_854_775_808, 9_223_372_036_854_775_807]
      end
      obj.i64s = [-9_223_372_036_854_775_808, 2_147_483_647]
      assert_raises(RangeError) do
        obj.i64s = [-9_223_372_036_854_775_808, 9_223_372_036_854_775_807, 9_223_372_036_854_775_808]
      end

      assert_raises(RangeError) do
        obj.s64s = [-9_223_372_036_854_775_809, -9_223_372_036_854_775_808, 9_223_372_036_854_775_807]
      end
      obj.s64s = [-9_223_372_036_854_775_808, 9_223_372_036_854_775_807]
      assert_raises(RangeError) do
        obj.s64s = [-9_223_372_036_854_775_808, 9_223_372_036_854_775_807, 9_223_372_036_854_775_808]
      end

      assert_raises(RangeError) do
        obj.u64s = [-1, 0, 2_147_483_647]
      end
      obj.u64s = [0, 18_446_744_073_709_551_615]
      assert_raises(RangeError) do
        obj.u64s = [0, 18_446_744_073_709_551_615, 18_446_744_073_709_551_616]
      end
    end

    private

    def parse_string(string)
      ProtoBoeuf.parse_string(string)
    end

    def parse_file(string)
      ProtoBoeuf.parse_file(string)
    end

    def protoboeuf_parser?
      true
    end

    def ruby_script_header(string)
      string.split(/^(module|class)/).first
    end
  end

  class ProtoCCodeGenTest < CodeGenTest
    def protoboeuf_parser?
      false
    end

    def import_path
      File.expand_path("fixtures", __dir__)
    end

    def parse_string(string)
      binfile = Tempfile.new
      Tempfile.create do |f|
        f.write(string)
        f.flush
        system("protoc -o #{binfile.path} -I/:'#{import_path}' #{f.path}")
      end
      binfile.rewind
      Google::Protobuf::FileDescriptorSet.decode(binfile.read)
    ensure
      binfile.unlink
    end

    def parse_file(path)
      string = File.binread(path)

      begin
        binfile = Tempfile.new
        Tempfile.create do |f|
          f.write(string)
          f.flush
          system("protoc -o #{binfile.path} -I/:'#{import_path}' #{f.path}")
        end
        binfile.rewind
        Google::Protobuf::FileDescriptorSet.decode(binfile.read)
      ensure
        binfile.unlink
      end
    end
  end
end
