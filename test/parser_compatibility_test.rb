require "helper"
require "google/protobuf"

module ProtoBoeuf
  class ParserCompatibilityTest < Test
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

    private

    def assert_same_value(theirs, ours)
      assert_equal(yield(theirs), yield(ours))
    end

    def parse_string(str)
      [parse_string_with_protoboeuf(str), parse_string_with_protoc(str)]
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
