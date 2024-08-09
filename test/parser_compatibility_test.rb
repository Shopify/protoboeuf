require "helper"
require "google/protobuf"

module ProtoBoeuf
  class ParserCompatibilityTest < Test
    def test_required_field
      ours, theirs = parse_string(<<-EOPROTO)
message Test1 {
  required uint32 u32 = 1;
  optional int32 i32 = 2;
}
      EOPROTO

      assert_equal 0, theirs.file.first.message_type.first.oneof_decl.length
      assert_equal 0, ours.file.first.message_type.first.oneof_decl.length

      assert_equal theirs.file.first.message_type.first.field.first.label,
        ours.file.first.message_type.first.field.first.label
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
      assert_equal theirs.file.length, ours.file.length
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

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.enum_type.length
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.enum_type.first.value.length
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.enum_type.first.value[1].name
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.enum_type.first.value[1].number
      end
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

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.length
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field.length
      end

      theirs.file.first.message_type.first.field.length.times do |i|
        item_a = theirs.file.first.message_type.first.field[i]
        item_b = ours.file.first.message_type.first.field[i]

        assert_equal item_a.type, item_b.type
        assert_equal item_a.name, item_b.name
      end
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

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.length
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.name
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field.length
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field.first.name
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field.first.number
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field.first.type_name
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field.first.type
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field[1].type
      end
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

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.oneof_decl.length
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.oneof_decl.first.name
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field.length
      end

      theirs.file.first.message_type.first.field.length.times do |i|
        their_field = theirs.file.first.message_type.first.field[i]
        our_field = ours.file.first.message_type.first.field[i]

        assert_equal their_field.type, our_field.type, "types should equal"
        assert_equal their_field.name, our_field.name, "names should equal"
        assert_equal their_field.number, our_field.number, "numbers should equal"
        assert_equal their_field.has_oneof_index?, our_field.has_oneof_index?, "oneof_index should equal"
        assert_equal their_field.label, our_field.label

        if their_field.has_oneof_index?
          assert_equal their_field.oneof_index, our_field.oneof_index, "oneof_index should equal"
        end
      end
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

      theirs.file.first.message_type.first.field.each_with_index do |their_field, i|
        our_field = ours.file.first.message_type.first.field[i]
        assert_equal their_field.label, our_field.label

        if their_field.options
          assert_equal false, our_field.options.packed
          assert_equal their_field.options.packed, our_field.options.packed
        end
      end
    end

    def test_map_type
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message MapItem {
  map<string, int64> something_foo = 1;
}
      EOPROTO

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field.first.name
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field.first.type_name
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field.first.label
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.field.first.type
      end

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.nested_type.length
      end

      theirs.file.first.message_type.first.nested_type.each_with_index do |their_msg, i|
        our_msg = ours.file.first.message_type.first.nested_type[i]

        assert_equal their_msg.field.length, our_msg.field.length
        assert their_msg.options.map_entry
        assert our_msg.options.map_entry

        their_msg.field.each_with_index do |their_field, j|
          our_field = our_msg.field[j]
          assert_equal their_field.name, our_field.name
          assert_equal their_field.number, our_field.number
          assert_equal their_field.label, our_field.label
          assert_equal their_field.type, our_field.type
        end
      end
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

      assert_same_value(theirs, ours) do |obj|
        obj.file.first.message_type.first.nested_type.length
      end
      theirs.file.first.message_type.first.nested_type.each_with_index do |their_msg, i|
        our_msg = ours.file.first.message_type.first.nested_type[i]

        assert_equal their_msg.name, our_msg.name
        assert_equal their_msg.field.length, our_msg.field.length
      end
    end

    def test_optional
      ours, theirs = parse_string(<<-EOPROTO)
syntax = "proto3";

message OneItem {
  optional uint32 a = 1;
  optional uint32 b = 2;
}
      EOPROTO

      their_message = theirs.file.first.message_type.first
      our_message = ours.file.first.message_type.first

      their_oneof = their_message.oneof_decl.first
      our_oneof = our_message.oneof_decl.first

      their_field = their_message.field.last
      our_field = our_message.field.last

      assert_equal their_field.oneof_index, our_field.oneof_index

      assert their_field.proto3_optional
      assert our_field.proto3_optional

      assert_equal 2, our_message.oneof_decl.length
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

      2.times do |i|
        assert_equal theirs.file.first.message_type.first.field[i].options.packed,
          ours.file.first.message_type.first.field[i].options.packed
      end

      assert_nil theirs.file.first.message_type.first.field[2].options
      assert_nil ours.file.first.message_type.first.field[2].options
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

    private

    def assert_same_value(theirs, ours)
      assert_equal(yield(theirs), yield(ours))
    end

    def parse_string(str)
      [parse_string_with_protoboeuf(str), parse_string_with_protoc(str)]
      #[nil, parse_string_with_protoc(str)]
    end

    def parse_string_with_protoboeuf(string)
      ProtoBoeuf.parse_string(string)
    end

    def parse_string_with_protoc(string)
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
