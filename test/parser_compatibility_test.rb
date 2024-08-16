require "helper"
require "tempfile"
require "google/protobuf/descriptor_pb"

module ProtoBoeuf
  class ParserCompatibilityTest < Test
    def test_map_complex_types
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message Foo {
  message Bar {
    string test = 1;
  }

  map<string, Bar> attributes = 5;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_message_name_resolution
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message Foo {
  uint64 value = 1;

  message Bar {
    uint64 value = 1;
  }
}

message TestEmbeds {
  message Baz {
    uint64 value = 1;
  }

  Baz baz = 3;
  Foo foo = 1;
  Foo.Bar bar = 2;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_repeated
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message TestRepeatedField {
  repeated uint32 e = 1;
  int64 another_value = 2;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_oneof_embedded
      ours, theirs = parse_string(<<-EOPROTO)
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

      assert_same_tree(theirs, ours)
    end

    def test_oneof_enum
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

enum TestEnum {
  FOO = 0;
}

message Test1 {
  optional string string_field = 1;
  optional string string_field2 = 2;

  oneof oneof_field {
    TestEnum enum_1 = 3;
  }

  oneof oneof_field2 {
    TestEnum enum_2 = 4;
  }
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_nested_enum
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message Test1 {
  enum NestedEnum {
    FOO = 0;
    BAR = 1;
  }

  NestedEnum kind = 1;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_very_nested_enum
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message Test1 {
  message Test2 {
    message Test3 {
      enum NestedEnum {
        FOO = 0;
        BAR = 1;
      }

      NestedEnum kind = 1;
    }
  }
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_optional_and_non_optional_field
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message ManyOptional {
  optional uint64 b = 2;
  uint64 c = 3;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_required_field
      ours, theirs = parse_string(<<-EOPROTO)
message Test1 {
  required uint32 u32 = 1;
  optional int32 i32 = 2;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_file
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

enum SimpleEnum {
  ZERO = 0;
  ONE = 1;
  TWO = 2;
}
      EOPROTO
      assert_same_tree(theirs, ours)
    end

    def test_top_level_enum
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

enum SimpleEnum {
  ZERO = 0;
  ONE = 1;
  TWO = 2;
}
      EOPROTO
      assert_same_tree(theirs, ours)
    end

    def test_simple_types
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message AllTypes {
  double a = 1;
  float b = 2;
  int64 c = 3;
  uint64 d = 4;
  int32 e = 5;
  fixed64 f = 6;
  fixed32 g = 7;
  bool h = 8;
  string i = 9;
  bytes j = 10;
  uint32 k = 11;
  sfixed32 l = 12;
  sfixed64 m = 13;
  sint32 n = 14;
  sint64 o = 15;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_enum_field
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

enum SimpleEnum {
  ZERO = 0;
  ONE = 1;
  TWO = 2;
}

message HasEnum {
  SimpleEnum a = 1;
  uint32 b = 2;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_oneof_fields
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message OrigFoo {
  oneof foo_bar_bif {
    uint32 i = 1;
    string s = 2;
  }
  sint32 q = 7;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_qualifiers
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message OneItem {
  optional uint32 a = 1;
  repeated uint32 b = 2;
  uint32 c = 3;
  repeated uint32 ids = 4 [packed = false];
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_map_type
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message MapItem {
  map<string, int64> something_foo = 1;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_submessages
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message BucketObj {
  message OrigFoo {
    sint32 q = 1;
  }
  sint32 fi = 2;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_optional
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message OneItem {
  optional uint32 a = 1;
  optional uint32 b = 2;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_options
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";
message Test1 {
  repeated int32 a = 1 [packed = false];
  repeated int32 b = 2 [packed = true];
  repeated int32 c = 3;
}
      EOPROTO

      assert_same_tree(theirs, ours)
    end

    def test_simple_codegen
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message OneItem {
  uint32 a = 1;
}
      EOPROTO

      assert_equal ProtoBoeuf::CodeGen.new(ours).to_ruby,
                   ProtoBoeuf::CodeGen.new(theirs).to_ruby
    end

    def test_fixture_file
      ours, theirs = parse_string(File.binread('./test/fixtures/test.proto'))
      assert_same_tree theirs, ours
    end

    def test_typed_file
      ours, theirs = parse_string(File.binread('./test/fixtures/typed_test.proto'))
      assert_same_tree theirs, ours
    end

    private

    def assert_same_tree(expected, actual)
      assert_equal expected.file.length, actual.file.length
      expected.file.each_with_index do |file, i|
        assert_same_file file, actual.file[i]
      end
    end

    def assert_same_file(expected, actual)
      # check messages
      assert_equal expected.message_type.length, actual.message_type.length

      expected.message_type.each_with_index do |msg, i|
        assert_same_message(msg, actual.message_type[i])
      end

      # check enum types
      assert_equal expected.enum_type.length, actual.enum_type.length

      expected.enum_type.each_with_index do |msg, i|
        assert_same_enum(msg, actual.enum_type[i])
      end
    end

    def assert_same_enum(expected, actual)
      assert_equal expected.name, actual.name
      assert_equal expected.value.length, actual.value.length

      expected.value.each_with_index do |enum_value, i|
        assert_same_enum_value(enum_value, actual.value[i])
      end
    end

    def assert_same_enum_value(expected, actual)
      assert_equal expected.name, actual.name
      assert_equal expected.number, actual.number
    end

    def assert_same_oneof(expected, actual)
      assert_equal expected.name, actual.name
    end

    def assert_same_message(expected, actual)
      assert_equal expected.name, actual.name, "Message name should match"

      # check oneof decls
      assert_equal expected.oneof_decl.length, actual.oneof_decl.length, "oneof_decl length should match"

      expected.oneof_decl.each_with_index do |oneof, i|
        assert_same_oneof(oneof, actual.oneof_decl[i])
      end

      # check fields
      assert_equal expected.field.length, actual.field.length, "field length should match"

      expected.field.each_with_index do |field, i|
        assert_same_field(field, actual.field[i])
      end

      # check enum types
      assert_equal expected.enum_type.length, actual.enum_type.length, "enum_type length should match"

      expected.enum_type.each_with_index do |msg, i|
        assert_same_enum(msg, actual.enum_type[i])
      end

      # check nested types
      assert_equal expected.nested_type.length, actual.nested_type.length, "nested_type length should match"

      expected.nested_type.each_with_index do |msg, i|
        assert_same_message(msg, actual.nested_type[i])
      end
    end

    def assert_same_field(expected, actual)
      assert_equal expected.name, actual.name, "Names should match"
      assert_equal expected.number, actual.number, "Number should match"
      assert_equal expected.label, actual.label, "Label should match #{expected.name} #{actual.class}"
      assert_equal expected.type, actual.type, "Type should match on #{expected.name}"

      if expected.type_name.nil?
        assert_nil actual.type_name
      else
        assert_equal expected.type_name, actual.type_name
      end

      assert_equal(!!expected.has_oneof_index?, !!actual.has_oneof_index?, "has_oneof_index? should match on #{actual.inspect}")
      if expected.has_oneof_index?
        assert_equal(expected.oneof_index, actual.oneof_index, "oneof_index should match")
      end
      assert_equal(!!expected.proto3_optional, !!actual.proto3_optional, "proto3_optional should match")

      if expected.options
        assert_equal(!!expected.options.packed, !!actual.options.packed, "packed option should match")
      else
        refute !!actual.options
      end
    end

    def parse_string(str)
      [parse_string_with_protoboeuf(str), parse_string_with_protoc(str)]
    end

    def parse_string_with_protoboeuf(string)
      ProtoBoeuf.parse_string(string)
    end

    def make_binary_proto(string)
      binfile = Tempfile.new
      Tempfile.create do |f|
        f.write string
        f.flush
        system("protoc -o #{binfile.path} -I / #{f.path}")
      end
      binfile.rewind
      binfile.read
    ensure
      binfile.unlink
    end

    def parse_string_with_protoc(string)
      data = make_binary_proto(string)
      decode_file_descriptor_set data
    end

    def decode_file_descriptor_set(data)
      Google::Protobuf::FileDescriptorSet.decode data
    end
  end

  class ASTCompatibility < ParserCompatibilityTest
    def test_fixture_file
      skip
      super
    end

    private

    def decode_file_descriptor_set(data)
      theirs = super
      require "protoboeuf/protobuf/descriptor"

      ours = ProtoBoeuf::Protobuf::FileDescriptorSet.decode data

      assert_same_tree(theirs, ours)

      theirs
    end
  end
end
