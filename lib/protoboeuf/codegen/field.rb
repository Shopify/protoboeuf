# frozen_string_literal: true

require "forwardable"

# Adds some convenience methods to Google::Protobuf::FieldDescriptorProto
module ProtoBoeuf
  class CodeGen
    class Field
      attr_reader :original_field, :message, :syntax

      extend Forwardable

      def_delegators :@original_field,
        :has_oneof_index?,
        :json_name,
        :label,
        :name,
        :number,
        :oneof_index,
        :options,
        :type,
        :type_name

      def initialize(field:, message:, syntax:)
        @original_field = field
        @message = message
        @syntax = syntax
      end

      def optional?
        original_field.proto3_optional || (label == :LABEL_OPTIONAL && !proto3?)
      end

      def repeated?
        label == :LABEL_REPEATED
      end

      def map_field?
        return false unless repeated?

        map_name = type_name.split(".").last
        message.nested_type.any? { |type| type.name == map_name && type.options&.map_entry }
      end

      class MapType < Struct.new(:key, :value); end

      def map_type
        return false unless repeated?

        map_name = type_name.split(".").last
        message.nested_type.find { |type| type.name == map_name && type.options&.map_entry }.tap do |descriptor|
          raise ArgumentError, "Not a map field" if descriptor.nil?

          return MapType.new(
            key: self.class.new(field: descriptor.field[0], message:, syntax:),
            value: self.class.new(field: descriptor.field[1], message:, syntax:),
          )
        end
      end

      def proto3?
        "proto3" == syntax
      end

      # Return an instance variable name for use in generated code
      def iv_name
        "@#{name}"
      end

      RUBY_KEYWORDS = [
        "__ENCODING__",
        "__LINE__",
        "__FILE__",
        "BEGIN",
        "END",
        "alias",
        "and",
        "begin",
        "break",
        "case",
        "class",
        "def",
        "defined?",
        "do",
        "else",
        "elsif",
        "end",
        "ensure",
        "false",
        "for",
        "if",
        "in",
        "module",
        "next",
        "nil",
        "not",
        "or",
        "redo",
        "rescue",
        "retry",
        "return",
        "self",
        "super",
        "then",
        "true",
        "undef",
        "unless",
        "until",
        "when",
        "while",
        "yield",
      ].to_set

      # Return code for reading the local variable returned by `lvar_name`
      def lvar_read
        if RUBY_KEYWORDS.include?(name)
          "binding.local_variable_get(:#{name})"
        elsif name =~ /^[A-Z_]/
          "_#{name}"
        else
          name
        end
      end

      def lvar_name
        if RUBY_KEYWORDS.include?(name)
          name
        elsif name =~ /^[A-Z_]/
          "_#{name}"
        else
          name
        end
      end

      def kwarg_name
        name
      end

      def kwarg_read
        if RUBY_KEYWORDS.include?(name)
          "binding.local_variable_get(:#{name})"
        else
          name
        end
      end

      def predicate_method_name
        "has_#{name}?"
      end

      def oneof_selection_field?
        message.oneof_decl.include?(original_field)
      end
    end
  end
end
