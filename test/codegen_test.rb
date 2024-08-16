require "helper"
require "tempfile"
require "google/protobuf/descriptor_pb"

module ProtoBoeuf
  class CodeGenTest < Test
    def test_uppercase_field_name
      unit = parse_string(<<-EOPROTO)
syntax = "proto3";

message Foo {
  uint64 FieldName = 1;
}
      EOPROTO

      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }

      foo = klass::Foo.new
      assert_equal 0, foo.FieldName
      foo.FieldName = 1

      foo = klass::Foo.decode klass::Foo.encode foo
      assert_equal 1, foo.FieldName
    end

    def test_map_complex_types
      unit = parse_string(<<-EOPROTO)
syntax = "proto3";

message Foo {
  message Bar {
    string test = 1;
  }

  map<string, Bar> attributes = 5;
}
      EOPROTO

      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }

      foo = klass::Foo.new
      foo.attributes["bar"] = klass::Foo::Bar.new
      foo.attributes["bar"].test = "hello"

      foo = klass::Foo.decode klass::Foo.encode foo
    end

    def test_decode_embedder
      unit = parse_string(<<-EOPROTO)
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

      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }

      data = klass::TestEmbedder.encode(klass::TestEmbedder.new.tap { |x|
        x.value = klass::TestEmbeddee.new(value: 5678)
        x.message = "hello world"
      })

      obj = klass::TestEmbedder.decode data
      assert_equal 5678, obj.value.value
      assert_equal "hello world", obj.message
    end

    def test_decode_repeated
      skip "fixme"

      unit = parse_string(<<-EOPROTO)
syntax = "proto3";

message TestRepeatedField {
  repeated uint32 e = 1;
  int64 another_value = 2;
}
      EOPROTO
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }

      msg = klass::TestRepeatedField.new(e: [1, 2, 3, 0xFF], another_value: 0xCAFE)

      data = ::TestRepeatedField.encode(::TestRepeatedField.new.tap { |x|
        x.e[0] = 1
        x.e[1] = 2
        x.e[2] = 3
        x.e[3] = 0xFF
        x.another_value = 0xCAFE
      })

      assert_equal data.bytes, klass::TestRepeatedField.encode(msg).bytes
    end

    def test_oneof_decoding
      unit = parse_string(<<-EOPROTO)
syntax = "proto3";

message TestMessageWithOneOf {
  oneof oneof_field {
    string oneof_str = 7;
  }
}
      EOPROTO
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }

      msg = klass::TestMessageWithOneOf.new(oneof_str: "hello")
      klass::TestMessageWithOneOf.decode klass::TestMessageWithOneOf.encode msg
    end

    def test_optional_fields
      unit = parse_string(<<-EOPROTO)
syntax = "proto3";

message ManyOptional {
  optional uint64 b = 2;
  uint64 c = 3;
}
      EOPROTO
      gen = CodeGen.new unit
      assert Class.new { self.class_eval gen.to_ruby }
    end

    def test_enum_field
      unit = parse_string(<<-EOPROTO)
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
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }

      msg = klass::Test1.new
      assert_equal :FOO, msg.enum_1
      msg.enum_1 = :BAR

      msg = klass::Test1.decode(klass::Test1.encode(msg))
      assert_equal :BAR, msg.enum_1
    end

    def test_required_field
      unit = parse_string(<<-EOPROTO)
message Test1 {
  required uint32 u32 = 1;
  optional int32 i32 = 2;
}
      EOPROTO
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }

      msg = klass::Test1.new
      msg.u32 = 1234
      msg.i32 = 1234

      msg = klass::Test1.decode(klass::Test1.encode(msg))
      assert_equal(1234, msg.u32)
      assert_equal(1234, msg.i32)
    end

    def test_map_fields
      unit = parse_string(<<-EOPROTO)
syntax = "proto3";

message Test1 {
  map<string, int32> map_field = 1;
}
      EOPROTO
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }

      msg = klass::Test1.new
      assert_equal({}, msg.map_field)

      msg.map_field["foo"] = 1234

      msg = klass::Test1.decode(klass::Test1.encode(msg))
      assert_equal({"foo" => 1234}, msg.map_field)
    end

    def test_oneof
      unit = parse_string(<<-EOPROTO)
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
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }

      msg = klass::TestMessageWithOneOf.new
      assert_equal 0, msg.oneof_u32
      assert_nil msg.oneof_msg
      assert_equal "", msg.oneof_str
      assert_nil msg.oneof_field

      msg.oneof_str = "hello"
      assert_equal "hello", msg.oneof_str
      assert_equal :oneof_str, msg.oneof_field

      msg.oneof_u32 = 123
      assert_equal 123, msg.oneof_u32
      assert_equal :oneof_u32, msg.oneof_field
    end

    def test_make_ruby
      unit = parse_string('syntax = "proto3"; message TestMessage { string id = 1; uint64 shop_id = 2; bool boolean = 3; }')
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }
      obj = klass::TestMessage.new
      assert_equal "", obj.id
      assert_equal 0, obj.shop_id
      assert_equal false, obj.boolean
    end

    def test_int32
      unit = parse_string('syntax = "proto3"; message Test1 { optional int32 a = 1; }')
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }
      obj = klass::Test1.new
      assert_equal 0, obj.a
    end

    def test_fixture_file
      unit = parse_file('./test/fixtures/test.proto')

      gen = CodeGen.new unit

      klass = Class.new { self.class_eval gen.to_ruby }
      obj = klass::Test1.new
      assert_equal 0, obj.a

      assert_equal [], klass::TestRepeatedField.new.e
    end

    def test_fields_keyword_end
      unit = parse_string('syntax = "proto3"; message Test1 { optional int32 end = 1; }')
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }
      obj = klass::Test1.new(end: 1234)
      assert_equal 1234, obj.end
    end

    def test_fields_keyword_class
      unit = parse_string('syntax = "proto3"; message Test1 { optional int32 class = 1; }')
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }
      obj = klass::Test1.new(class: 1234)
      assert_equal 1234, obj.class
    end

    def test_fields_keyword_nil
      unit = parse_string('syntax = "proto3"; message Test1 { optional int32 nil = 1; }')
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }
      obj = klass::Test1.new(nil: 1234)
      assert_equal 1234, obj.nil
    end

    def test_repeated
      unit = parse_string('syntax = "proto3"; message Test1 { repeated int32 repeated_ints = 1; }')
      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }
      obj = klass::Test1.new
      assert_equal([], obj.repeated_ints)
      obj.repeated_ints << 123

      obj = klass::Test1.decode(klass::Test1.encode(obj))
      assert_equal([123], obj.repeated_ints)
    end

    def test_generate_types
      proto = File.read("test/fixtures/typed_test.proto")
      unit = parse_string(proto)

      gen = CodeGen.new unit, generate_types: true

      File.write("test/fixtures/typed_test.generated.rb", gen.to_ruby)

      # The goal of this test is to ensure that we generate valid sorbet signatures.
      #
      # This tests will break whenever any implementation of field encoding/deconding etc changes.
      # While this is not great, writing tests that ensure that signatures are generated
      # correctly without pulling in all of sorbet is at the very least incredibly complex.
      # So this is the solution for now.
      assert_equal File.read("test/fixtures/typed_test.correct.rb"), gen.to_ruby
    end

    def test_modules_with_package
      unit = parse_string(<<~PROTO)
        package example.code_gen.package;

        message Foo {}
      PROTO

      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }
      assert klass::Example::CodeGen::Package::Foo.new
    end

    def test_modules_with_ruby_package
      unit = parse_string(<<~PROTO)
        package example.proto;

        option ruby_package = "Example::Ruby::Package";

        message Foo {}
      PROTO

      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }
      assert klass::Example::Ruby::Package::Foo.new
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

      gen = CodeGen.new unit
      klass = Class.new { self.class_eval gen.to_ruby }
      obj = klass::Test1.new()

      assert_raises RangeError do
        obj.i32 = -2_147_483_649
      end
      obj.i32 = -2_147_483_648
      obj.i32 = 2_147_483_647
      assert_raises RangeError do
        obj.i32 = 2_147_483_648
      end

      assert_raises RangeError do
        obj.s32 = -2_147_483_649
      end
      obj.s32 = -2_147_483_648
      obj.s32 = 2_147_483_647
      assert_raises RangeError do
        obj.s32 = 2_147_483_648
      end

      assert_raises RangeError do
        obj.u32 = -1
      end
      obj.u32 = 0
      obj.u32 = 4_294_967_295
      assert_raises RangeError do
        obj.u32 = 4_294_967_296
      end

      assert_raises RangeError do
        obj.i64 = -9_223_372_036_854_775_809
      end
      obj.i64 = -9_223_372_036_854_775_808
      obj.i64 = 9_223_372_036_854_775_807
      assert_raises RangeError do
        obj.i64 = 9_223_372_036_854_775_808
      end

      assert_raises RangeError do
        obj.s64 = -9_223_372_036_854_775_809
      end
      obj.s64 = -9_223_372_036_854_775_808
      obj.s64 = 9_223_372_036_854_775_807
      assert_raises RangeError do
        obj.s64 = 9_223_372_036_854_775_808
      end

      assert_raises RangeError do
        obj.u64 = -1
      end
      obj.u64 = 0
      obj.u64 = 18_446_744_073_709_551_615
      assert_raises RangeError do
        obj.u64 = 18_446_744_073_709_551_616
      end

      assert_raises RangeError do
        obj.i32s = [-2_147_483_649, -2_147_483_648, 2_147_483_647]
      end
      obj.i32s = [-2_147_483_648, 2_147_483_647]
      assert_raises RangeError do
        obj.i32s = [-2_147_483_648, 2_147_483_647, 2_147_483_648]
      end

      assert_raises RangeError do
        obj.s32s = [-2_147_483_649, -2_147_483_648, 2_147_483_647]
      end
      obj.s32s = [-2_147_483_648, 2_147_483_647]
      assert_raises RangeError do
        obj.s32s = [-2_147_483_648, 2_147_483_647, 2_147_483_648]
      end

      assert_raises RangeError do
        obj.u32s = [-1, 0, 2_147_483_647]
      end
      obj.u32s = [0, 4_294_967_295]
      assert_raises RangeError do
        obj.u32s = [0, 4_294_967_295, 4_294_967_296]
      end

      assert_raises RangeError do
        obj.i64s = [-9_223_372_036_854_775_809, -9_223_372_036_854_775_808, 9_223_372_036_854_775_807]
      end
      obj.i64s = [-9_223_372_036_854_775_808, 2_147_483_647]
      assert_raises RangeError do
        obj.i64s = [-9_223_372_036_854_775_808, 9_223_372_036_854_775_807, 9_223_372_036_854_775_808]
      end

      assert_raises RangeError do
        obj.s64s = [-9_223_372_036_854_775_809, -9_223_372_036_854_775_808, 9_223_372_036_854_775_807]
      end
      obj.s64s = [-9_223_372_036_854_775_808, 9_223_372_036_854_775_807]
      assert_raises RangeError do
        obj.s64s = [-9_223_372_036_854_775_808, 9_223_372_036_854_775_807, 9_223_372_036_854_775_808]
      end

      assert_raises RangeError do
        obj.u64s = [-1, 0, 2_147_483_647]
      end
      obj.u64s = [0, 18_446_744_073_709_551_615]
      assert_raises RangeError do
        obj.u64s = [0, 18_446_744_073_709_551_615, 18_446_744_073_709_551_616]
      end
    end

    private

    def parse_string(string)
      ProtoBoeuf.parse_string string
    end

    def parse_file(string)
      ProtoBoeuf.parse_file string
    end
  end

  class ProtoCCodeGenTest < CodeGenTest
    def parse_string(string)
      begin
        binfile = Tempfile.new
        Tempfile.create do |f|
          f.write string
          f.flush
          system("protoc -o #{binfile.path} -I / #{f.path}")
        end
        binfile.rewind
        Google::Protobuf::FileDescriptorSet.decode binfile.read
      ensure
        binfile.unlink
      end
    end

    def parse_file(path)
      string = File.binread path

      begin
        binfile = Tempfile.new
        Tempfile.create do |f|
          f.write string
          f.flush
          system("protoc -o #{binfile.path} -I / #{f.path}")
        end
        binfile.rewind
        Google::Protobuf::FileDescriptorSet.decode binfile.read
      ensure
        binfile.unlink
      end
    end
  end
end
