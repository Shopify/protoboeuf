# frozen_string_literal: true

module ProtoBoeuf
  class CodeGen
    module TypeHelper
      TYPE_MAPPING = {
        :TYPE_INT32 => "Integer",
        :TYPE_SINT32 => "Integer",
        :TYPE_UINT32 => "Integer",
        :TYPE_INT64 => "Integer",
        :TYPE_SINT64 => "Integer",
        :TYPE_FIXED64 => "Integer",
        :TYPE_SFIXED64 => "Integer",
        :TYPE_FIXED32 => "Integer",
        :TYPE_SFIXED32 => "Integer",
        :TYPE_UINT64 => "Integer",
        :TYPE_STRING => "String",
        :TYPE_DOUBLE => "Float",
        :TYPE_FLOAT => "Float",
        :TYPE_BYTES => "String",
        :TYPE_ENUM => "Symbol",
        "google.protobuf.BoolValue" => "ProtoBoeuf::Protobuf::BoolValue",
        "google.protobuf.Int32Value" => "ProtoBoeuf::Protobuf::Int32Value",
        "google.protobuf.Int64Value" => "ProtoBoeuf::Protobuf::Int64Value",
        "google.protobuf.UInt32Value" => "ProtoBoeuf::Protobuf::UInt32Value",
        "google.protobuf.UInt64Value" => "ProtoBoeuf::Protobuf::UInt64Value",
        "google.protobuf.FloatValue" => "ProtoBoeuf::Protobuf::FloatValue",
        "google.protobuf.DoubleValue" => "ProtoBoeuf::Protobuf::DoubleValue",
        "google.protobuf.StringValue" => "ProtoBoeuf::Protobuf::StringValue",
        "google.protobuf.BytesValue" => "ProtoBoeuf::Protobuf::BytesValue",
        "google.protobuf.Timestamp" => "ProtoBoeuf::Protobuf::Timestamp",
      }.freeze

      def type_signature(params: nil, returns: nil, newline: false)
        return "" unless generate_types

        sig = []
        sig << "params(#{params.map { |k, v| "#{k}: #{convert_type(v)}" }.join(", ")})" if params
        sig << "returns(#{returns})" if returns
        sig << "void" unless returns

        complete_sig = "sig { #{sig.join(".")} }"
        complete_sig += "\n" if newline

        complete_sig
      end

      def initialize_type_signature(fields)
        return "" unless generate_types

        type_signature(params: fields_to_params(fields), newline: true)
      end

      def reader_type_signature(field)
        type_signature(returns: convert_field_type(field))
      end

      def extend_t_sig
        return "" unless generate_types

        "extend T::Sig"
      end

      private

      def convert_type(converted_type, optional: false, array: false)
        converted_type = "T::Array[#{converted_type}]" if array
        converted_type = "T.nilable(#{converted_type})" if optional
        converted_type
      end

      def convert_field_type(field)
        converted_type = if map_field?(field)
          map_type = self.map_type(field)
          "T::Hash[#{convert_field_type(map_type.field[0])}, #{convert_field_type(map_type.field[1])}]"
        else
          case field.type
          when :TYPE_BOOL
            "T::Boolean"
          when :TYPE_MESSAGE
            field.type_name.delete_prefix(".").split(".").join("::")
          else
            TYPE_MAPPING.fetch(field.type)
          end
        end

        convert_type(
          converted_type,
          optional: field.label == :TYPE_OPTIONAL,
          array: field.label == :LABEL_REPEATED && !map_field?(field),
        )
      end

      def field_to_params(field)
        [field.name, convert_field_type(field)]
      end

      def fields_to_params(fields)
        fields
          .flat_map { |field| field_to_params(field) }
          .each_slice(2)
          .to_h
      end
    end
  end
end
