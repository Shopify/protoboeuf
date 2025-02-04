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

      def test_iv_name
        fields = fields_for_proto_message(<<~PROTO)
          syntax = "proto3";

          message MyMessage {
            int32 field1 = 1;
            string field_2 = 2;
          }
        PROTO

        assert_equal("@field1", fields["field1"].iv_name)
        assert_equal("@field_2", fields["field_2"].iv_name)
      end

      def test_lvar_name
        fields = fields_for_proto_message(<<~PROTO)
          syntax = "proto3";

          message MyMessage {
            int32 field1 = 1;
            int32 Field2 = 2;
            int32 _field3 = 3;
            int32 unless = 4; // Matches a Ruby reserved word
          }
        PROTO

        assert_equal("field1", fields["field1"].lvar_name)
        assert_equal("_Field2", fields["Field2"].lvar_name)
        assert_equal("__field3", fields["_field3"].lvar_name)
        assert_equal("unless", fields["unless"].lvar_name)
      end

      def test_lvar_read
        fields = fields_for_proto_message(<<~PROTO)
          syntax = "proto3";

          message MyMessage {
            int32 field1 = 1;
            int32 Field2 = 2;
            int32 _field3 = 3;
            int32 unless = 4; // Matches a Ruby reserved word
          }
        PROTO

        assert_equal("field1", fields["field1"].lvar_read)
        assert_equal("_Field2", fields["Field2"].lvar_read)
        assert_equal("__field3", fields["_field3"].lvar_read)
        assert_equal("binding.local_variable_get(:unless)", fields["unless"].lvar_read)
      end

      def test_predicate_method_name
        fields = fields_for_proto_message(<<~PROTO)
          syntax = "proto3";

          message MyMessage {
            optional int32 field1 = 1;
          }
        PROTO

        assert_equal("has_field1?", fields["field1"].predicate_method_name)
      end

      def test_oneof_selection_field?
        fields = fields_for_proto_message(<<~PROTO)
          syntax = "proto3";

          message MyMessage {
            oneof my_oneof {
              int32 field1 = 1;
              string field2 = 2;
            }
            int32 field3 = 3;
          }
        PROTO

        assert_predicate(fields["my_oneof"], :oneof_selection_field?, "my_oneof should be a oneof selection field")
        refute_predicate(fields["field1"], :oneof_selection_field?, "field1 should not be a oneof selection field")
        refute_predicate(fields["field2"], :oneof_selection_field?, "field2 should not be a oneof selection field")
        refute_predicate(fields["field3"], :oneof_selection_field?, "field3 should not be a oneof selection field")
      end

      private

      def fields_for_proto_message(proto_string)
        unit = parse_proto_string(proto_string)

        syntax = unit.file.first.syntax
        message = unit.file.first.message_type.first

        (message.field.to_a + message.oneof_decl.to_a).group_by(&:name).transform_values do |fields|
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
