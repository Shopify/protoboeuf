module ProtoBoeuf
  class CodeGen
    module TypeHelper
      TYPE_MAPPING = {
        "int32" => "Integer",
        "sint32" => "Integer",
        "uint32" => "Integer",
        "int64" => "Integer",
        "sint64" => "Integer",
        "uint64" => "Integer",
        "string" => "String",
        "double" => "Float",
        "bytes" => "", # TODO: this needs the correct type
        "TimeRange" => "", # TODO: this needs the correct type
        "google.protobuf.Timestamp" => "", # TODO: this needs the correct type
      }.freeze

      def type_signature(params: nil, returns: nil, newline: false)
        return "" unless generate_types

        sig = []
        sig << "params(#{params.map { |k, v| "#{k}: #{convert_type(v)}"}.join(", ")})" if params
        sig << "returns(#{returns})" if returns
        sig << "void" unless returns

        complete_sig = "sig { #{sig.join(".")} }"
        return complete_sig unless newline

        complete_sig += "\n"
      end

      def initialize_type_signature(fields)
        return "" unless generate_types

        type_signature(params: fields_to_params(fields), newline: true)
      end

      def reader_type_signature(type)
        if type.is_a?(Field)
          type_signature(returns: convert_field_type(type))
        else
          type_signature(returns: convert_type(type))
        end
      end

      def extend_t_sig
        return "" unless generate_types

        return "extend T::Sig"
      end

      private

      def convert_type(type, optional: false, array: false)
        converted_type = TYPE_MAPPING[type] || type
        converted_type = "T::Array[#{converted_type}]" if array
        converted_type = "T.nilable(#{converted_type})" if optional
        converted_type
      end

      def convert_field_type(field)
        if field.map?
          "T::Hash[#{convert_field_type(field.key_field)}, #{convert_field_type(field.value_field)}]"
        else
          convert_type(field.type, optional: field.optional?, array: field.repeated?)
        end
      end

      def field_to_params(field)
        if field.oneof?
          field.fields.flat_map { |field| field_to_params(field) }
        elsif field.field?
          [field.name, convert_field_type(field)]
        else
          raise "Unsupported field #{f.inspect}"
        end
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
