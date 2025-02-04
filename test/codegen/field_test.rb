# frozen_string_literal: true

require "helper"
require "protoboeuf/codegen/field"

module ProtoBoeuf
  class CodeGen
    class FieldTest < ProtoBoeuf::Test
      def test_delegates_common_methods
        fields = fields_for_proto_message(<<~PROTO)
          syntax = "proto3";

          message MyMessage {
            optional int32 field1 = 1 [deprecated=true];
          }
        PROTO

        field = fields["field1"]

        [:name, :label, :type_name, :type, :number, :options, :oneof_index, :has_oneof_index?].each do |method_name|
          assert_equal(
            field.send(method_name),
            field.original_field.send(method_name),
            "expected CodeGen::Field to delegate ##{method_name}",
          )
        end
      end

      def test_proto2_optional
        fields = fields_for_proto_message(<<~PROTO)
          message MyMessage {
            optional int32 field1 = 1;
            required int32 field2 = 2;
          }
        PROTO

        assert_predicate(fields["field1"], :optional?, "field1 should be optional")
        refute_predicate(fields["field2"], :optional?, "field2 should not be optional")
      end

      def test_proto3_optional
        fields = fields_for_proto_message(<<~PROTO)
          syntax = "proto3";

          message MyMessage {
            optional int32 field1 = 1;
            int32 field2 = 2;
          }
        PROTO

        assert_predicate(fields["field1"], :optional?, "field1 should be optional")
        refute_predicate(fields["field2"], :optional?, "field2 should not be optional")
      end

      def test_repeated
        fields = fields_for_proto_message(<<~PROTO)
          syntax = "proto3";

          message MyMessage {
            repeated int32 field1 = 1;
            int32 field2 = 2;
          }
        PROTO

        assert_predicate(fields["field1"], :repeated?, "field1 should be repeated")
        refute_predicate(fields["field2"], :repeated?, "field2 should not be repeated")
      end

      def test_map_field?
        fields = fields_for_proto_message(<<~PROTO)
          syntax = "proto3";

          message MyMessage {
            map<string, string> field1 = 1;
            int32 field2 = 2;
          }
        PROTO

        assert_predicate(fields["field1"], :map_field?, "field1 should be a map field")
        refute_predicate(fields["field2"], :map_field?, "field2 should not be a map field")
      end

      def test_map_type
        fields = fields_for_proto_message(<<~PROTO)
          syntax = "proto3";

          message MyMessage {
            map<string, int32> field1 = 1;
            int32 field2 = 2;
          }
        PROTO

        map_type = fields["field1"].map_type
        assert_kind_of(CodeGen::Field::MapType, map_type)

        assert_kind_of(CodeGen::Field, map_type.key)
        assert_equal(:TYPE_STRING, map_type.key.type)

        assert_kind_of(CodeGen::Field, map_type.value)
        assert_equal(:TYPE_INT32, map_type.value.type)

        refute_predicate(fields["field2"], :map_type, "field2 should not have a map_type")
      end

      def test_proto3?
        proto_2_fields = fields_for_proto_message(<<~PROTO)
          message MyMessage {
            map<string, int32> field1 = 1;
          }
        PROTO

        refute_predicate(proto_2_fields["field1"], :proto3?, "CodeGen::Field#proto3? should return false for proto2")

        proto_3_fields = fields_for_proto_message(<<~PROTO)
          syntax = "proto3";

          message MyMessage {
            map<string, int32> field1 = 1;
          }
        PROTO

        assert_predicate(proto_3_fields["field1"], :proto3?, "CodeGen::Field#proto3? should return true for proto3")
      end

      private

      def fields_for_proto_message(proto_string)
        unit = parse_proto_string(proto_string)

        syntax = unit.file.first.syntax
        message = unit.file.first.message_type.first

        message.field.group_by(&:name).transform_values do |fields|
          CodeGen::Field.new(
            field: fields.first,
            message:,
            syntax:,
          )
        end
      end
    end
  end
end
