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
    end
  end
end
