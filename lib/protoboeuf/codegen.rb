# frozen_string_literal: true

require "erb"
require "syntax_tree"

module ProtoBoeuf
  class CodeGen
    require "protoboeuf/codegen/type_helper"
    require "protoboeuf/codegen/field"

    class EnumCompiler
      attr_reader :generate_types

      include TypeHelper

      class << self
        def result(enum, generate_types:, options: {})
          new(enum, generate_types:, options:).result
        end
      end

      attr_reader :enum

      def initialize(enum, generate_types:, options: {})
        @enum = enum
        @generate_types = generate_types
        @options = options
      end

      def result
        <<~RESULT
          module #{enum.name}
            #{values}

            #{lookup}

            #{resolve}
          end
        RESULT
      end

      private

      VALUES = ERB.new(<<~VALUES, trim_mode: "-")
        <%- enum.value.each do |const| -%>
          <%= const.name %> = <%= const.number %>
        <%- end -%>
      VALUES

      def values
        VALUES.result(binding)
      end

      LOOKUP = ERB.new(<<~LOOKUP, trim_mode: "-")
        <%= type_signature(params: { val: "Integer" }, returns: "Symbol", newline: true) %>
        def self.lookup(val)
          <%- enum.value.each do |const| -%>
            return :<%= const.name %> if val == <%= const.number %>
          <%- end -%>
        end
      LOOKUP

      def lookup
        LOOKUP.result(binding)
      end

      RESOLVE = ERB.new(<<~RESOLVE, trim_mode: "-")
        <%= type_signature(params: { val: "Symbol" }, returns: "Integer", newline: true) %>
        def self.resolve(val)
          <%- enum.value.each do |const| -%>
            return <%= const.number %> if val == :<%= const.name %>
          <%- end -%>
        end
      RESOLVE

      def resolve
        RESOLVE.result(binding)
      end
    end

    # Generates #to_h, #as_json, and #to_json methods
    class HashSerializationCompiler
      include TypeHelper

      attr_reader :message, :fields, :oneof_selection_fields, :generate_types

      class << self
        def result(...)
          new(...).result
        end
      end

      def initialize(message:, fields:, oneof_selection_fields:, generate_types:)
        @message = message
        @fields = fields.sort_by(&:number) # Serialize fields in their proto order
        @oneof_selection_fields = oneof_selection_fields
        @generate_types = generate_types
      end

      def result
        <<~RUBY
          #{type_signature(returns: "T::Hash[Symbol, T.untyped]")}
          def to_h
            result = {}

            #{declare_resolved_oneof_selection_lvars_rb}

            #{fields.map { |f| to_h_assign_statement_rb(f) }.join("\n")}

            result
          end

          #{type_signature(params: { options: "T::Hash[T.untyped, T.untyped]" }, returns: "T::Hash[Symbol, T.untyped]")}
          def as_json(options = {})
            result = {}

            #{declare_resolved_oneof_selection_lvars_rb}

            #{fields.map { |f| as_json_assign_statement_rb(f) }.join("\n")}

            result
          end

          #{type_signature(params: { as_json_options: "T::Hash[T.untyped, T.untyped]" }, returns: "String")}
          def to_json(as_json_options = {})
            require 'json'
            JSON.dump(as_json(as_json_options))
          end
        RUBY
      end

      private

      def resolved_oneof_selection_lvar(field)
        if field.oneof_selection_field?
          "resolved_#{field.lvar_name}"
        else
          resolved_oneof_selection_lvar(oneof_selection_fields[field.oneof_index])
        end
      end

      def declare_resolved_oneof_selection_lvars_rb
        return "" if oneof_selection_fields.none?

        oneof_selection_fields.map do |oneof_selection_field|
          "#{resolved_oneof_selection_lvar(oneof_selection_field)} = self.#{oneof_selection_field.name}"
        end.join("\n")
      end

      def to_h_assign_statement_rb(field)
        key = to_h_hash_key_rb(field)
        value = to_h_hash_value_rb(field)

        if field.has_oneof_index? && !field.optional?
          field_name = field.name.dump

          "result[#{key}] = #{value} if #{resolved_oneof_selection_lvar(field)} == :#{field_name}"
        else
          "result[#{key}] = #{value}"
        end
      end

      def to_h_hash_key_rb(field)
        ":#{field.name.dump}"
      end

      def to_h_hash_value_rb(field)
        return to_h_hash_value_for_map_rb(field) if field.map_field?

        # For primitives or arrays of primitives we can just use the instance variable value
        return field.iv_name unless field.type == :TYPE_MESSAGE

        if field.repeated?
          # repeated maps aren't possible so we don't have to worry about to_h arity or as_json not being defined
          "#{field.iv_name}.map(&:to_h)"
        else
          "#{field.iv_name}.to_h"
        end
      end

      def to_h_hash_value_for_map_rb(field)
        if field.map_type.value.type == :TYPE_MESSAGE
          "#{field.iv_name}.transform_values(&:to_h)"
        else
          field.iv_name
        end
      end

      def as_json_assign_statement_rb(field)
        key = as_json_hash_key_rb(field)
        value = as_json_hash_value_rb(field)

        if field.has_oneof_index? && !field.optional?
          field_name = field.name.dump

          "result[#{key}] = #{value} if #{resolved_oneof_selection_lvar(field)} == :#{field_name}"
        elsif field.repeated?
          value_var_name = "tmp_#{field.lvar_name}"

          <<~RUBY
            #{value_var_name} = #{value}

            result[#{key}] = #{value_var_name} if !options[:compact] || #{value_var_name}.any?
          RUBY
        elsif field.optional?
          "result[#{key}] = #{value} if !options[:compact] || #{field.predicate_method_name}"
        else
          "result[#{key}] = #{value}"
        end
      end

      def as_json_hash_key_rb(field)
        field.json_name.dump
      end

      def as_json_hash_value_rb(field)
        return as_json_hash_value_for_map_rb(field) if field.map_field?

        # For primitives or arrays of primitives we can just use the instance variable value
        return field.iv_name unless field.type == :TYPE_MESSAGE

        if field.repeated?
          # repeated maps aren't possible so we don't have to worry about to_h arity or as_json not being defined
          "#{field.iv_name}.map { |v| v.as_json(options) }"
        else
          "#{field.iv_name}.nil? ? {} : #{field.iv_name}.as_json(options)"
        end
      end

      def as_json_hash_value_for_map_rb(field)
        if field.map_type.value.type == :TYPE_MESSAGE
          "#{field.iv_name}.transform_values { |value| value.as_json(options) }"
        else
          field.iv_name
        end
      end
    end

    class MessageCompiler
      attr_reader :enum_field_types,
        :fields,
        :generate_types,
        :message,
        :oneof_fields,
        :oneof_selection_fields,
        :optional_fields,
        :requires,
        :syntax

      include TypeHelper

      class << self
        def result(message, toplevel_enums, generate_types:, requires:, syntax:, options: {})
          new(message, toplevel_enums, generate_types:, requires:, syntax:, options:).result
        end
      end

      def initialize(message, toplevel_enums, generate_types:, requires:, syntax:, options:)
        @message = message
        @optional_field_bit_lut = []
        @fields = @message.field.map do |field|
          CodeGen::Field.new(field:, message:, syntax:)
        end
        @enum_field_types = toplevel_enums.merge(message.enum_type.group_by(&:name))
        @requires = requires
        @generate_types = generate_types
        @has_submessage = false
        @syntax = syntax
        @options = options

        @required_fields = []
        @optional_fields = []
        @oneof_fields = []
        @enum_fields = []
        @oneof_selection_fields = []

        optional_field_count = 0

        @fields.each do |field|
          if field.optional?
            if field.type == :TYPE_ENUM
              @enum_fields << field
            else
              @optional_fields << field
            end
            @optional_field_bit_lut[field.number] = optional_field_count
            optional_field_count += 1
          elsif field.has_oneof_index?
            (@oneof_fields[field.oneof_index] ||= []) << field
          elsif field.type == :TYPE_ENUM
            @enum_fields << field
          else
            @required_fields << field
          end
        end

        # The AST treats "optional" fields in Proto3 as "oneof" fields.
        # But since there is only one of each of these "oneof" fields, there
        # is no reason to add an extra instance variable.  The "oneof_fields"
        # list only contains non-proto3_optional fields, so we're using that
        # to only iterate over actual "oneof" fields.
        @oneof_selection_fields = @oneof_fields.each_with_index.map do |item, i|
          item && CodeGen::Field.new(message:, field: message.oneof_decl[i], syntax:)
        end
      end

      def result
        "class #{message.name}\n" + class_body + "end\n"
      end

      private

      def class_body
        prelude +
          constants +
          enums +
          readers +
          writers +
          initialize_code +
          extra_api +
          decode +
          encode +
          conversion
      end

      def conversion
        HashSerializationCompiler.result(message:, fields:, oneof_selection_fields:, generate_types:)
      end

      def encode
        # FIXME: we should probably sort fields by field number
        type_signature(params: { buff: "String" }, returns: "String", newline: true) +
          "def _encode(buff)\n" +
          fields.map { |field| encode_subtype(field) }.compact.join("\n") +
          "buff << @_unknown_fields if @_unknown_fields\nbuff\n end\n\n"
      end

      def encode_subtype(field, value_expr = field.iv_name, tagged = true)
        if field.label == :LABEL_REPEATED
          if field.map_field?
            encode_map(field, value_expr, tagged)
          else
            encode_repeated(field, value_expr, tagged)
          end
        else
          encode_leaf_type(field, value_expr, tagged)
        end
      end

      def encode_leaf_type(field, value_expr, tagged)
        send("encode_#{field.type.to_s.downcase.delete_prefix("type_")}", field, value_expr, tagged)
      end

      def encode_tag(field)
        result = +""
        tag = (field.number << 3) | CodeGen.wire_type(field)
        while tag != 0
          byte = tag & 0x7F
          tag >>= 7
          tag &= (1 << 57) - 1
          byte |= 0x80 if tag != 0

          result << "buff << #{format("%#04x", byte)}\n"
        end
        result
      end

      def encode_length(field, len_expr)
        result = +""

        if CodeGen.wire_type(field) == LEN
          raise "length encoded fields must have a length expression" unless len_expr

          if len_expr != "len"
            result << "len = #{len_expr}\n"
          end

          result << uint64_code("len")
        end

        result
      end

      def encode_tag_and_length(field, tagged, len_expr = false)
        result = +""

        if tagged
          result << encode_tag(field)
          result << encode_length(field, len_expr)
        end

        result
      end

      def encode_bool(field, value_expr, tagged)
        # False/zero is the default value, so the false case encodes nothing
        <<~RUBY
          val = #{value_expr}
          if val == true
            #{encode_tag_and_length(field, tagged)}
            buff << 1
          elsif val == false
            # Default value, encode nothing
          else
            raise "bool values should be true or false"
          end
        RUBY
      end

      def encode_map(field, value_expr, tagged)
        map_type = field.map_type

        <<~RUBY
          map = #{value_expr}
          if map.size > 0
            old_buff = buff
            map.each do |key, value|
              buff = new_buffer = +''
              #{encode_subtype(map_type.key, "key", true)}
              #{encode_subtype(map_type.value, "value", true)}
              buff = old_buff
              #{encode_tag_and_length(field, true, "new_buffer.bytesize")}
              old_buff.concat(new_buffer)
            end
          end
        RUBY
      end

      def encode_oneof(field, value_expr, tagged)
        field.fields.map do |f|
          <<~RUBY
            if #{field.iv_name} == :"#{f.name}"
              #{encode_subtype(f, f.iv_name)}
            end
          RUBY
        end.join("\n")
      end

      def encode_repeated(field, value_expr, tagged)
        if CodeGen.packed?(field)
          <<~RUBY
            list = #{value_expr}
            if list.size > 0
              #{encode_tag(field)}

              # Save the buffer size before appending the repeated bytes
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"

              # write each item
              list.each do |item|
                #{encode_leaf_type(field, "item", false)}
              end

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end
            end
          RUBY
        else
          <<~RUBY
            list = #{value_expr}
            if list.size > 0
              list.each do |item|
                #{encode_leaf_type(field, "item", true)}
              end
            end
          RUBY
        end
      end

      def encode_string(field, value_expr, tagged)
        # Empty string is default value, so encodes nothing
        if String.method_defined?(:append_as_bytes) && @options[:append_as_bytes] != false
          <<~RUBY
            val = #{value_expr}
            if((len = val.bytesize) > 0)
              #{encode_tag_and_length(field, tagged, "len")}
              buff.append_as_bytes(val)
            end
          RUBY
        else
          <<~RUBY
            val = #{value_expr}
            if((len = val.bytesize) > 0)
              #{encode_tag_and_length(field, tagged, "len")}
              buff << (val.ascii_only? ? val : val.b)
            end
          RUBY
        end
      end

      def encode_bytes(field, value_expr, tagged)
        # Empty bytes is default value, so encodes nothing
        if String.method_defined?(:append_as_bytes) && @options[:append_as_bytes] != false
          <<~RUBY
            val = #{value_expr}
            if((bs = val.bytesize) > 0)
              #{encode_tag_and_length(field, tagged, "bs")}
              buff.append_as_bytes(val)
            end
          RUBY
        else
          <<~RUBY
            val = #{value_expr}
            if((bs = val.bytesize) > 0)
              #{encode_tag_and_length(field, tagged, "bs")}
              buff.concat(val.b)
            end
          RUBY
        end
      end

      def encode_message(field, value_expr, tagged)
        @has_submessage = true

        <<~RUBY
          val = #{value_expr}
          if val
            #{encode_tag(field)}
            # Save the buffer size before appending the submessage
            current_len = buff.bytesize

            # Write a single dummy byte to later store encoded length
            buff << 42 # "*"
            val._encode(buff)

            # Calculate the submessage's size
            submessage_size = buff.bytesize - current_len - 1

            # Hope the size fits in one byte
            byte = submessage_size & 0x7F
            submessage_size >>= 7
            byte |= 0x80 if submessage_size > 0
            buff.setbyte(current_len, byte)

            # If the sub message was bigger
            if submessage_size > 0
              current_len += 1

              # compute how much we need to shift
              encoded_int_len = 0
              remaining_size = submessage_size
              while remaining_size != 0
                remaining_size >>= 7
                encoded_int_len += 1
              end

              # Make space in the string with dummy bytes
              buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

              # Overwrite the dummy bytes with the encoded length
              while submessage_size != 0
                byte = submessage_size & 0x7F
                submessage_size >>= 7
                byte |= 0x80 if submessage_size > 0
                buff.setbyte(current_len, byte)
                current_len += 1
              end
            end

            buff
          end
        RUBY
      end

      def uint64_code(local)
        <<~RUBY
          while #{local} != 0
            byte = #{local} & 0x7F
            #{local} >>= 7
            byte |= 0x80 if #{local} > 0
            buff << byte
          end
        RUBY
      end

      def encode_uint64(field, value_expr, tagged)
        # Zero is the default value, so it encodes zero bytes
        <<~RUBY
          val = #{value_expr}
          if val != 0
            #{encode_tag_and_length(field, tagged)}
            #{uint64_code("val")}
          end
        RUBY
      end

      # Ideally this should happen when setting the field value
      # rather than when doing the encoding
      alias_method :encode_uint32, :encode_uint64

      def encode_int64(field, value_expr, tagged)
        # Zero is the default value, so it encodes zero bytes
        <<~RUBY
          val = #{value_expr}
          if val != 0
            #{encode_tag_and_length(field, tagged)}
            #{encode_varint}
          end
        RUBY
      end

      def encode_varint(dest = "buff")
        <<~RUBY
          while val != 0
            byte = val & 0x7F

            val >>= 7
            # This drops the top bits,
            # Otherwise, with a signed right shift,
            # we get infinity one bits at the top
            val &= (1 << 57) - 1

            byte |= 0x80 if val != 0
            #{dest} << byte
          end
        RUBY
      end

      # The same encoding logic is used for int32 and int64
      alias_method :encode_int32, :encode_int64

      # Bools and enums are both encoded as if they were int32s
      alias_method :encode_enum, :encode_int32

      def encode_sint64(field, value_expr, tagged)
        # Zero is the default value, so it encodes zero bytes
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}

          # Zigzag encoding:
          # Positive values encoded as 2 * n (even)
          # Negative values encoded as 2 * |n| - 1 (odd)
          val = if val >= 0
            2 * val
          else
            (-2 * val) - 1
          end

          #{uint64_code("val")}
        end
        eocode
      end

      # The same encoding logic is used for sint32 and sint64
      alias_method :encode_sint32, :encode_sint64

      def encode_double(field, value_expr, tagged)
        # False/zero is the default value, so the zero case encodes nothing
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}
          [val].pack('E', buffer: buff)
        end
        eocode
      end

      def encode_float(field, value_expr, tagged)
        # False/zero is the default value, so the zero case encodes nothing
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}
          [val].pack('e', buffer: buff)
        end
        eocode
      end

      def encode_fixed64(field, value_expr, tagged)
        # False/zero is the default value, so the zero case encodes nothing
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}
          [val].pack('Q<', buffer: buff)
        end
        eocode
      end

      def encode_sfixed64(field, value_expr, tagged)
        # False/zero is the default value, so the zero case encodes nothing
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}
          [val].pack('q<', buffer: buff)
        end
        eocode
      end

      def encode_fixed32(field, value_expr, tagged)
        # False/zero is the default value, so the zero case encodes nothing
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}
          [val].pack('L<', buffer: buff)
        end
        eocode
      end

      def encode_sfixed32(field, value_expr, tagged)
        # False/zero is the default value, so the zero case encodes nothing
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}
          [val].pack('l<', buffer: buff)
        end
        eocode
      end

      def prelude
        <<~RUBY
          #{extend_t_sig}
          #{type_signature(params: { buff: "String" }, returns: message.name)}
          def self.decode(buff)
            allocate.decode_from(buff.b, 0, buff.bytesize)
          end

          #{type_signature(params: { obj: message.name }, returns: "String")}
          def self.encode(obj)
            obj._encode("".b)
          end
        RUBY
      end

      def enums
        message.enum_type.map do |enum|
          EnumCompiler.result(enum, generate_types:)
        end.join("\n")
      end

      def constants
        message.nested_type.reject { |x| x.options&.map_entry }.map do |x|
          self.class.new(x, enum_field_types, generate_types:, requires:, syntax:, options: @options).result
        end.join("\n")
      end

      def readers
        required_readers + enum_readers + optional_readers + oneof_readers
      end

      def enum_readers
        fields = @enum_fields
        return "" if fields.empty?

        "  # enum readers\n" +
          fields.map { |field|
            "def #{field.name}; #{enum_name(field)}.lookup(#{field.iv_name}) || #{field.iv_name}; end"
          }.join("\n") + "\n"
      end

      def enum_name(field)
        raise ArgumentError unless field.type == :TYPE_ENUM

        class_name(field.type_name)
      end

      # Translate ".package.name::NestedMessage" into "Package::Name::NestedMessage".
      def class_name(type)
        translate_well_known(type).delete_prefix(".").split(/\.|::/).map do |part|
          if part =~ /^[A-Z]/
            part
          else
            part.split("_").map do |s|
              # We need to "constantize" the fields that don't look like constants
              # but if they already do we don't want to break the casing.
              s.match?(/^[A-Z]/) ? s : s.capitalize
            end.join
          end
        end.join("::")
      end

      def required_readers
        fields = @required_fields.select do |field|
          !field.type != :TYPE_ENUM
        end

        "# required field readers\n" +
          fields.map do |field|
            "#{reader_type_signature(field)}\nattr_reader :#{field.name}\n"
          end.join("\n") +
          "\n\n"
      end

      def optional_readers
        return "" if optional_fields.empty?

        "# optional field readers\n" +
          optional_fields.map do |field|
            "#{reader_type_signature(field)}\nattr_reader :#{field.name}\n"
          end.join("\n") +
          "\n\n"
      end

      def oneof_readers
        return "" if oneof_fields.empty?

        "# oneof field readers\n" +
          oneof_fields.map.with_index do |sub_fields, i|
            next unless sub_fields

            field = message.oneof_decl[i]

            [
              type_signature(returns: "Symbol"),
              "attr_reader :#{field.name}",
              sub_fields.map do |sub_field|
                "#{reader_type_signature(sub_field)}\nattr_reader :#{sub_field.name}"
              end,
            ].join("\n")
          end.join("\n") + "\n\n"
      end

      def writers
        required_writers + enum_writers + optional_writers + oneof_writers
      end

      def enum_writers
        fields = @enum_fields
        return "" if fields.empty?

        "# enum writers\n" +
          fields.map do |field|
            "def #{field.name}=(v); #{field.iv_name} = #{enum_name(field)}.resolve(v) || v; end"
          end.join("\n") + "\n\n"
      end

      def required_writers
        fields = @required_fields

        return "" if fields.empty?

        fields.map do |field|
          <<~RUBY
            #{type_signature(params: { v: convert_field_type(field) })}
            def #{field.name}=(v)
              #{bounds_check(field, "v")}
              #{field.iv_name} = v
            end
          RUBY
        end.join("\n") + "\n"
      end

      def optional_writers
        return "" if optional_fields.empty?

        "# BEGIN writers for optional fields\n" +
          optional_fields.map { |field|
            <<~RUBY
              #{type_signature(params: { v: convert_field_type(field) })}
              def #{field.name}=(v)
                #{bounds_check(field, "v")}
                #{set_bitmask(field)}
                #{field.iv_name} = v
              end
            RUBY
          }.join("\n") +
          "  # END writers for optional fields\n\n"
      end

      def oneof_writers
        return "" if oneof_fields.empty?

        "# BEGIN writers for oneof fields\n" +
          oneof_fields.map.with_index do |sub_fields, i|
            next unless sub_fields

            oneof = message.oneof_decl[i]
            sub_fields.map do |field|
              <<~RUBY
                def #{field.name}=(v)
                  #{bounds_check(field, "v")}
                  @#{oneof.name} = :#{field.name}
                  #{field.iv_name} = v
                end
              RUBY
            end.join("\n")
          end.join("\n") +
          "# END writers for oneof fields\n\n"
      end

      def initialize_code
        initialize_type_signature(fields) +
          "def initialize(" + initialize_signature + ")\n" +
          init_bitmask(message) +
          initialize_oneofs +
          fields.map { |field|
            if field.has_oneof_index? && !field.optional?
              initialize_oneof(field, message)
            else
              initialize_field(field)
            end
          }.join("\n") + "\nend\n\n"
      end

      def initialize_oneofs
        @oneof_selection_fields.map do |field|
          "#{field.iv_name} = nil # oneof field"
        end.join("\n") + "\n"
      end

      def initialize_oneof(field, msg)
        oneof = CodeGen::Field.new(message: msg, field: msg.oneof_decl[field.oneof_index], syntax:)

        <<~RUBY
          if #{field.lvar_read} == nil
            #{field.iv_name} = #{default_for(field)}
          else
            #{bounds_check(field, field.lvar_read)}
            #{oneof.iv_name} = :#{field.name}
            #{field.iv_name} = #{field.lvar_read}
          end
        RUBY
      end

      def initialize_field(field)
        if field.optional?
          initialize_optional_field(field)
        elsif field.type == :TYPE_ENUM
          initialize_enum_field(field)
        else
          initialize_required_field(field)
        end
      end

      def initialize_optional_field(field)
        set_field_to_var = if field.type == :TYPE_ENUM
          initialize_enum_field(field)
        else
          "#{field.iv_name} = #{field.lvar_read}"
        end

        <<~RUBY
          if #{field.lvar_read} == nil
            #{field.iv_name} = #{default_for(field)}
          else
            #{bounds_check(field, field.lvar_read).chomp}
            #{set_bitmask(field)}
            #{set_field_to_var}
          end
        RUBY
      end

      def initialize_required_field(field)
        <<~RUBY
          #{bounds_check(field, field.lvar_read).chomp}
          #{field.iv_name} = #{field.lvar_read}
        RUBY
      end

      def initialize_enum_field(field)
        "#{field.iv_name} = #{enum_name(field)}.resolve(#{field.name}) || #{field.lvar_read}"
      end

      def extra_api
        <<~RUBY
          #{type_signature(params: { _options: "T::Hash" }, returns: "String")}
          def to_proto(_options = {})
            self.class.encode(self)
          end

          #{optional_predicates}
        RUBY
      end

      def optional_predicates
        return "" if optional_fields.empty?

        optional_fields.map do |field|
          <<~RUBY
            #{type_signature(returns: "T::Boolean")}
            def #{field.predicate_method_name}
              #{test_bitmask(field)}
            end
          RUBY
        end.join("\n") + "\n"
      end

      def decode
        type_signature(params: { buff: String, index: Integer, len: Integer }, returns: message.name, newline: true) +
          DECODE_METHOD.result(binding)
      end

      def oneof_field_readers
        fields = oneof_fields + oneof_fields.flat_map(&:fields)
        return "" if fields.empty?

        "attr_reader " + fields.map { |f| ":" + f.name }.join(", ")
      end

      TYPE_BOUNDS = {
        TYPE_UINT32: [0, 4_294_967_295],
        TYPE_INT32: [-2_147_483_648, 2_147_483_647],
        TYPE_SINT32: [-2_147_483_648, 2_147_483_647],
        TYPE_UINT64: [0, 18_446_744_073_709_551_615],
        TYPE_INT64: [-9_223_372_036_854_775_808, 9_223_372_036_854_775_807],
        TYPE_SINT64: [-9_223_372_036_854_775_808, 9_223_372_036_854_775_807],
      }.freeze

      PULL_VARINT = ERB.new(<<~ERB, trim_mode: "-")
        if (byte0 = buff.getbyte(index)) < 0x80
          index += 1
          byte0
        elsif (byte1 = buff.getbyte(index + 1)) < 0x80
          index += 2
          (byte1 << 7) | (byte0 & 0x7F)
        elsif (byte2 = buff.getbyte(index + 2)) < 0x80
          index += 3
          (byte2 << 14) |
            ((byte1 & 0x7F) << 7) |
            (byte0 & 0x7F)
        elsif (byte3 = buff.getbyte(index + 3)) < 0x80
          index += 4
          (byte3 << 21) |
            ((byte2 & 0x7F) << 14) |
            ((byte1 & 0x7F) << 7) |
            (byte0 & 0x7F)
        elsif (byte4 = buff.getbyte(index + 4)) < 0x80
          index += 5
          (byte4 << 28) |
            ((byte3 & 0x7F) << 21) |
            ((byte2 & 0x7F) << 14) |
            ((byte1 & 0x7F) << 7) |
            (byte0 & 0x7F)
        elsif (byte5 = buff.getbyte(index + 5)) < 0x80
          index += 6
          (byte5 << 35) |
            ((byte4 & 0x7F) << 28) |
            ((byte3 & 0x7F) << 21) |
            ((byte2 & 0x7F) << 14) |
            ((byte1 & 0x7F) << 7) |
            (byte0 & 0x7F)
        elsif (byte6 = buff.getbyte(index + 6)) < 0x80
          index += 7
          (byte6 << 42) |
            ((byte5 & 0x7F) << 35) |
            ((byte4 & 0x7F) << 28) |
            ((byte3 & 0x7F) << 21) |
            ((byte2 & 0x7F) << 14) |
            ((byte1 & 0x7F) << 7) |
            (byte0 & 0x7F)
        elsif (byte7 = buff.getbyte(index + 7)) < 0x80
          index += 8
          (byte7 << 49) |
            ((byte6 & 0x7F) << 42) |
            ((byte5 & 0x7F) << 35) |
            ((byte4 & 0x7F) << 28) |
            ((byte3 & 0x7F) << 21) |
            ((byte2 & 0x7F) << 14) |
            ((byte1 & 0x7F) << 7) |
            (byte0 & 0x7F)
        elsif (byte8 = buff.getbyte(index + 8)) < 0x80
          index += 9
          (byte8 << 56) |
            ((byte7 & 0x7F) << 49) |
            ((byte6 & 0x7F) << 42) |
            ((byte5 & 0x7F) << 35) |
            ((byte4 & 0x7F) << 28) |
            ((byte3 & 0x7F) << 21) |
            ((byte2 & 0x7F) << 14) |
            ((byte1 & 0x7F) << 7) |
            (byte0 & 0x7F)
        elsif (byte9 = buff.getbyte(index + 9)) < 0x80
          index += 10

          <%- if sign == :i64 -%>
          # Negative 32 bit integers are still encoded with 10 bytes
          # handle 2's complement negative numbers
          # If the top bit is 1, then it must be negative.
          -(((~((byte9 << 63) |
            ((byte8 & 0x7F) << 56) |
            ((byte7 & 0x7F) << 49) |
            ((byte6 & 0x7F) << 42) |
            ((byte5 & 0x7F) << 35) |
            ((byte4 & 0x7F) << 28) |
            ((byte3 & 0x7F) << 21) |
            ((byte2 & 0x7F) << 14) |
            ((byte1 & 0x7F) << 7) |
            (byte0 & 0x7F))) & 0xFFFF_FFFF_FFFF_FFFF) + 1)
          <%- end -%>

          <%- if sign == :i32 -%>
          # Negative 32 bit integers are still encoded with 10 bytes
          # handle 2's complement negative numbers
          # If the top bit is 1, then it must be negative.
          -(((~((byte9 << 63) |
            ((byte8 & 0x7F) << 56) |
            ((byte7 & 0x7F) << 49) |
            ((byte6 & 0x7F) << 42) |
            ((byte5 & 0x7F) << 35) |
            ((byte4 & 0x7F) << 28) |
            ((byte3 & 0x7F) << 21) |
            ((byte2 & 0x7F) << 14) |
            ((byte1 & 0x7F) << 7) |
            (byte0 & 0x7F))) & 0xFFFF_FFFF) + 1)
          <%- end -%>

          <%- if sign == false -%>
          (byte9 << 63) |
            ((byte8 & 0x7F) << 56) |
            ((byte7 & 0x7F) << 49) |
            ((byte6 & 0x7F) << 42) |
            ((byte5 & 0x7F) << 35) |
            ((byte4 & 0x7F) << 28) |
            ((byte3 & 0x7F) << 21) |
            ((byte2 & 0x7F) << 14) |
            ((byte1 & 0x7F) << 7) |
            (byte0 & 0x7F)
          <%- end -%>
        else
          raise "integer decoding error"
        end
      ERB

      PULL_STRING = ERB.new(<<~ERB, trim_mode: "-")
        value = <%= pull_varint %>

        <%= dest %> <%= operator %> buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
        index += value
      ERB

      PULL_BYTES = ERB.new(<<~ERB, trim_mode: "-")
        value = <%= pull_varint %>

        <%= dest %> <%= operator %> buff.byteslice(index, value)
        index += value
      ERB

      PULL_SINT32 = ERB.new(<<~ERB, trim_mode: "-")
        ## PULL SINT32
        value = <%= pull_varint %>

        # If value is even, then it's positive
        <%= dest %> <%= operator %> (if value.even?
          value >> 1
        else
          -((value + 1) >> 1)
        end)
        ## END PULL SINT32
      ERB

      DECODE_METHOD = ERB.new(<<~ERB, trim_mode: "-")
        def decode_from(buff, index, len)
          <%= init_bitmask(message) %>
          <%- for field in @oneof_selection_fields -%>
            <%= field.iv_name %> = nil # oneof field
          <%- end -%>
          <%- for field in fields -%>
            <%= field.iv_name %> = <%= default_for(field) %>
          <%- end -%>

          return self if index >= len
          <%- unless fields.empty? -%>
          <%= pull_tag %>
          <%- end -%>

          found = true
          while true
            # If we have looped around since the last found tag this one is
            # unexpected, so discard it and continue.
            if !found
              wire_type = tag & 0x7

              unknown_bytes = +"".b
              val = tag
              <%= encode_varint("unknown_bytes") %>

              case wire_type
              when <%= VARINT %>
                i = 0
                while true
                  newbyte = buff.getbyte(index)
                  index += 1
                  break if newbyte.nil?
                  unknown_bytes << newbyte
                  break if newbyte < 0x80
                  i += 1
                  break if i > 9
                end
              when <%= I64 %>
                unknown_bytes << buff.byteslice(index, 8)
                index += 8
              when <%= LEN %>
                value = <%= pull_varint %>

                val = value
                <%= encode_varint("unknown_bytes") %>

                unknown_bytes << buff.byteslice(index, value)
                index += value
              when <%= I32 %>
                unknown_bytes << buff.byteslice(index, 4)
                index += 4
              else
                raise "unknown wire type \#{wire_type}"
              end
              (@_unknown_fields ||= +"".b) << unknown_bytes
              return self if index >= len
              <%= pull_tag %>
            end
            found = false

            <%- fields.each do |field| -%>
              <%- if !field.has_oneof_index? || field.optional? -%>
            if tag == <%= tag_for_field(field, field.number) %>
              found = true
              <%= decode_code(field) %>
              <%= set_bitmask(field) if field.optional? %>
              return self if index >= len
              <%- if !reads_next_tag?(field) -%>
              <%= pull_tag %>
              <%- end -%>
            end
              <%- else -%>
            if tag == <%= tag_for_field(field, field.number) %>
              found = true
              <%= decode_code(field) %>
              @<%= message.oneof_decl[field.oneof_index].name %> = :<%= field.name %>
              return self if index >= len
              <%= pull_tag %>
            end
              <%- end -%>
            <%- end -%>

            return self if index >= len
          end
        end
      ERB

      PACKED_REPEATED = ERB.new(<<~ERB)
        <%= pull_uint64("value", "=") %>
        goal = index + value
        list = <%= field.iv_name %>
        while true
          break if index >= goal
          <%= decode_subtype(field, field.type, "list", "<<") %>
        end
      ERB

      def pull_tag
        str = pull_uint64("tag", "=")

        if $DEBUG
          str += <<~'RUBY'
            puts "reading field #{tag >> 3} type: #{tag & 0x7} #{tag}"
          RUBY
        end

        str
      end

      def default_for(field)
        if field.label == :LABEL_REPEATED
          if field.map_field?
            "{}"
          else
            "[]"
          end
        else
          case field.type
          when :TYPE_UINT64, :TYPE_INT32, :TYPE_SINT32, :TYPE_UINT32, :TYPE_INT64,
            :TYPE_SINT64, :TYPE_FIXED64, :TYPE_FIXED32, :TYPE_SFIXED32,
            :TYPE_SFIXED64, :TYPE_ENUM
            0
          when :TYPE_STRING, :TYPE_BYTES
            '""'
          when :TYPE_DOUBLE, :TYPE_FLOAT
            0.0
          when :TYPE_BOOL
            false
          when :TYPE_MESSAGE
            "nil"
          else
            raise NotImplementedError, field.type.to_s
          end
        end
      end

      def initialize_signature
        fields.flat_map do |f|
          if f.has_oneof_index? || f.optional?
            "#{f.lvar_name}: nil"
          else
            "#{f.lvar_name}: #{default_for(f)}"
          end
        end.join(", ")
      end

      def tag_for_field(field, idx)
        format("%#02x", idx << 3 | CodeGen.wire_type(field))
      end

      def decode_subtype(field, type, dest, operator)
        if field.type == :TYPE_ENUM
          pull_int64(dest, operator)
        else
          case type
          when :TYPE_STRING   then pull_string(dest, operator)
          when :TYPE_BYTES    then pull_bytes(dest, operator)
          when :TYPE_UINT64   then pull_uint64(dest, operator)
          when :TYPE_INT64    then pull_int64(dest, operator)
          when :TYPE_INT32    then pull_int32(dest, operator)
          when :TYPE_UINT32   then pull_uint32(dest, operator)
          when :TYPE_SINT32   then pull_sint32(dest, operator)
          when :TYPE_SINT64   then pull_sint64(dest, operator)
          when :TYPE_BOOL     then pull_boolean(dest, operator)
          when :TYPE_DOUBLE   then pull_double(dest, operator)
          when :TYPE_FIXED64  then pull_fixed_int64(dest, operator)
          when :TYPE_FIXED32  then pull_fixed_int32(dest, operator)
          when :TYPE_SFIXED64 then pull_fixed_int64(dest, operator)
          when :TYPE_SFIXED32 then pull_fixed_int32(dest, operator)
          when :TYPE_FLOAT    then pull_float(dest, operator)
          when :TYPE_MESSAGE
            if field.type_name.start_with?(".google")
              pull_message(field.type_name, dest, operator)
            else
              pull_message(field.type_name.sub(/^\./, "").gsub(".", "::"), dest, operator)
            end
          else
            raise "Unknown field type #{type}"
          end
        end
      end

      def pull_double(dest, operator)
        "#{dest} #{operator} buff.unpack1('E', offset: index); index += 8"
      end

      def pull_float(dest, operator)
        "#{dest} #{operator} buff.unpack1('e', offset: index); index += 4"
      end

      def pull_fixed_int64(dest, operator)
        "#{dest} #{operator} (" + 8.times.map { |i|
                                    "(buff.getbyte(index + #{i}) << #{i * 8})"
                                  }.join(" | ") + "); index += 8"
      end

      def pull_fixed_int32(dest, operator)
        "#{dest} #{operator} (" + 4.times.map { |i|
                                    "(buff.getbyte(index + #{i}) << #{i * 8})"
                                  }.join(" | ") + "); index += 4"
      end

      def decode_map(field)
        map_type = field.map_type

        <<~RUBY
          ## PULL_MAP
          map = #{field.iv_name}
          while tag == #{tag_for_field(field, field.number)}
            #{pull_uint64("value", "=")}
            index += 1 # skip the tag, assume it's the key
            return self if index >= len
            #{decode_subtype(map_type.key, map_type.key.type, "key", "=")}
            index += 1 # skip the tag, assume it's the value
            #{decode_subtype(map_type.value, map_type.value.type, "map[key]", "=")}
            return self if index >= len
            #{pull_tag}
          end
        RUBY
      end

      def decode_repeated(field)
        <<~RUBY
          ## DECODE REPEATED
          list = #{field.iv_name}
          while true
            #{decode_subtype(field, field.type, "list", "<<")}
            return self if index >= len
            #{pull_tag}
            break unless tag == #{tag_for_field(field, field.number)}
          end
          ## END DECODE REPEATED
        RUBY
      end

      def translate_well_known(type)
        google_match = /^[.]google[.](protobuf|api)/.match(type)

        return type unless google_match

        submodule = google_match[1]

        if type == ".google.protobuf.Duration"
          @requires << "protoboeuf/google/protobuf/duration"
        end

        if type == ".google.protobuf.BoolValue"
          @requires << "protoboeuf/google/protobuf/boolvalue"
        end

        if type == ".google.protobuf.Int32Value"
          @requires << "protoboeuf/google/protobuf/int32value"
        end

        if type == ".google.protobuf.Int64Value"
          @requires << "protoboeuf/google/protobuf/int64value"
        end

        if type == ".google.protobuf.UInt32Value"
          @requires << "protoboeuf/google/protobuf/uint32value"
        end

        if type == ".google.protobuf.UInt64Value"
          @requires << "protoboeuf/google/protobuf/uint64value"
        end

        if type == ".google.protobuf.FloatValue"
          @requires << "protoboeuf/google/protobuf/floatvalue"
        end

        if type == ".google.protobuf.DoubleValue"
          @requires << "protoboeuf/google/protobuf/doublevalue"
        end

        if type == ".google.protobuf.StringValue"
          @requires << "protoboeuf/google/protobuf/stringvalue"
        end

        if type == ".google.protobuf.BytesValue"
          @requires << "protoboeuf/google/protobuf/bytesvalue"
        end

        if type == ".google.protobuf.Timestamp"
          @requires << "protoboeuf/google/protobuf/timestamp"
        end

        if type == ".google.protobuf.Any"
          @requires << "protoboeuf/google/protobuf/any"
        end

        if type == ".google.protobuf.DescriptorProto"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.EnumDescriptorProto"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.EnumOptions"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.EnumValueDescriptorProto"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.EnumValueOptions"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.ExtensionRangeOptions"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.FeatureSet"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.FeatureSetDefaults"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.FieldDescriptorProto"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.FieldOptions"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.FileDescriptorProto"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.FileOptions"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.GeneratedCodeInfo"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.MessageOptions"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.MethodDescriptorProto"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.MethodOptions"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.OneofDescriptorProto"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.OneofOptions"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.ServiceDescriptorProto"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.ServiceOptions"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.SourceCodeInfo"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.UninterpretedOption"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.DescriptorProto.ExtensionRange"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.DescriptorProto.ReservedRange"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.EnumDescriptorProto.EnumReservedRange"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.ExtensionRangeOptions.Declaration"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.FeatureSetDefaults.FeatureSetEditionDefault"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.FieldOptions.EditionDefault"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.FieldOptions.FeatureSupport"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.GeneratedCodeInfo.Annotation"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.SourceCodeInfo.Location"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.UninterpretedOption.NamePart"
          @requires << "protoboeuf/google/protobuf/descriptor"
        end

        if type == ".google.protobuf.FieldMask"
          @requires << "protoboeuf/google/protobuf/field_mask"
        end

        if type == ".google.protobuf.Struct"
          @requires << "protoboeuf/google/protobuf/struct"
        end

        if type == ".google.protobuf.Value"
          @requires << "protoboeuf/google/protobuf/struct"
        end

        if type == ".google.protobuf.ListValue"
          @requires << "protoboeuf/google/protobuf/struct"
        end

        if type == ".google.protobuf.NullValue"
          @requires << "protoboeuf/google/protobuf/struct"
        end

        if type == ".google.api.FieldBehavior"
          @requires << "protoboeuf/google/api/field_behavior"
        end

        "::ProtoBoeuf::Google::#{submodule.capitalize}::" + type.split(".").drop(3).join("::")
      end

      def pull_message(type, dest, operator)
        translated_type = translate_well_known(type)

        <<~RUBY
          ## PULL_MESSAGE
          #{pull_uint64("msg_len", "=")}
          #{dest} #{operator} #{class_name(translated_type)}.allocate.decode_from(buff, index, index += msg_len)
          ## END PULL_MESSAGE
        RUBY
      end

      def pull_int64(dest, operator)
        <<~RUBY
          ## PULL_INT64
          #{dest} #{operator} #{pull_varint(sign: :i64)}
          ## END PULL_INT64
        RUBY
      end

      def pull_int32(dest, operator)
        <<~RUBY
          ## PULL_INT32
          #{dest} #{operator} #{pull_varint(sign: :i32)}
          ## END PULL_INT32
        RUBY
      end

      def pull_sint32(dest, operator)
        PULL_SINT32.result(binding)
      end

      def pull_varint(sign: false)
        PULL_VARINT.result(binding)
      end

      alias_method :pull_sint64, :pull_sint32

      def pull_string(dest, operator)
        <<~RUBY
          ## PULL_STRING
          #{PULL_STRING.result(binding)}
          ## END PULL_STRING
        RUBY
      end

      def pull_bytes(dest, operator)
        <<~RUBY
          ## PULL_BYTES
          #{PULL_BYTES.result(binding)}
          ## END PULL_BYTES
        RUBY
      end

      def pull_uint64(dest, operator)
        <<~RUBY
          ## PULL_UINT64
          #{dest} #{operator} #{pull_varint}
          ## END PULL_UINT64
        RUBY
      end

      alias_method :pull_uint32, :pull_uint64

      def pull_boolean(dest, operator)
        <<~RUBY
          ## PULL BOOLEAN
          #{dest} #{operator} (buff.getbyte(index) == 1)
          index += 1
          ## END PULL BOOLEAN
        RUBY
      end

      def decode_code(field)
        if field.label == :LABEL_REPEATED
          if field.map_field?
            decode_map(field)
          elsif CodeGen.packed?(field)
            PACKED_REPEATED.result(binding)
          else
            decode_repeated(field)
          end
        else
          decode_subtype(field, field.type, field.iv_name, "=")
        end
      end

      def init_bitmask(msg)
        optionals = optional_fields

        if optionals.empty?
          ""
        else
          "    @_bitmask = 0\n\n"
        end
      end

      def set_bitmask(field) # rubocop:disable Naming/AccessorMethodName
        i = @optional_field_bit_lut.fetch(field.number) || raise("optional field should have a bit")
        "@_bitmask |= #{format("%#018x", 1 << i)}"
      end

      def bounds_check(field, value_name)
        bounds = TYPE_BOUNDS[field.type]
        return "" unless bounds

        lower_bound, upper_bound = bounds
        if field.label == :LABEL_REPEATED
          <<~RUBY
            #{value_name}.each do |v|
              unless #{lower_bound} <= v && v <= #{upper_bound}
                raise RangeError, "Value (\#{v}}) for field #{field.name} is out of bounds (#{lower_bound}..#{upper_bound})"
              end
            end
          RUBY
        else
          <<~RUBY
            unless #{lower_bound} <= #{value_name} && #{value_name} <= #{upper_bound}
              raise RangeError, "Value (\#{#{value_name}}) for field #{field.name} is out of bounds (#{lower_bound}..#{upper_bound})"
            end
          RUBY
        end
      end

      def test_bitmask(field)
        i = @optional_field_bit_lut.fetch(field.number) || raise("optional field should have a bit")
        "(@_bitmask & #{format("%#018x", 1 << i)}) == #{format("%#018x", 1 << i)}"
      end

      def reads_next_tag?(field)
        field.map_field? || (field.repeated? && !CodeGen.packed?(field))
      end
    end

    attr_reader :generate_types

    def initialize(ast, generate_types: false)
      @ast = ast # unit node
      @generate_types = generate_types
    end

    def to_ruby(this_file = nil, options = {})
      requires = Set.new
      @ast.file.each do |file|
        modules = resolve_modules(file)
        head = "# encoding: ascii-8bit\n"
        head += "# rubocop:disable all\n"
        head += "# typed: false\n" if generate_types
        head += "# frozen_string_literal: true\n"
        head += "\n"

        toplevel_enums = file.enum_type.group_by(&:name)
        body = file.enum_type.map { |enum| EnumCompiler.result(enum, generate_types:, options:) }.join + "\n"
        body += file.message_type.map do |message|
          MessageCompiler.result(message, toplevel_enums, generate_types:, requires:, syntax: file.syntax, options:)
        end.join

        head += requires.reject { |r| r == this_file }.map { |r| "require #{r.dump}" }.join("\n") + "\n\n"
        head += modules.map { |m| "module #{m}\n" }.join

        tail = "\n" + modules.map { "end" }.join("\n")

        begin
          return SyntaxTree.format(head + body + tail)
        rescue
          $stderr.puts head + body + tail
          raise
        end
      end
    end

    def resolve_modules(file)
      ruby_package = file.options&.ruby_package

      if ruby_package && !ruby_package.empty?
        return ruby_package.split("::")
      end

      (file.package || "").split(".").filter_map do |m|
        m.split("_").map(&:capitalize).join unless m.empty?
      end
    end

    VARINT = 0
    I64 = 1
    LEN = 2
    I32 = 5

    PACKED_TYPES = [
      :TYPE_DOUBLE,
      :TYPE_FLOAT,
      :TYPE_INT32,
      :TYPE_INT64,
      :TYPE_UINT32,
      :TYPE_UINT64,
      :TYPE_SINT32,
      :TYPE_SINT64,
      :TYPE_FIXED32,
      :TYPE_FIXED64,
      :TYPE_SFIXED32,
      :TYPE_SFIXED64,
      :TYPE_BOOL,
    ].to_set.freeze

    class << self
      # Returns whether or not a repeated field is packed.
      # In Proto3 documents, repeated fields default to packed
      def packed?(field)
        raise ArgumentError unless field.label == :LABEL_REPEATED

        return PACKED_TYPES.include?(field.type) unless field.options

        field.options.packed
      end

      def wire_type(field)
        if field.label == :LABEL_REPEATED && packed?(field)
          LEN
        elsif field.type == :TYPE_ENUM
          VARINT
        else
          case field.type
          when :TYPE_STRING, :TYPE_BYTES
            LEN
          when :TYPE_INT64, :TYPE_INT32, :TYPE_UINT64, :TYPE_BOOL, :TYPE_SINT32, :TYPE_SINT64, :TYPE_UINT32
            VARINT
          when :TYPE_DOUBLE, :TYPE_FIXED64, :TYPE_SFIXED64
            I64
          when :TYPE_FLOAT, :TYPE_FIXED32, :TYPE_SFIXED32
            I32
          when :TYPE_MESSAGE
            LEN
          # when /[A-Z]+\w+/ # FIXME: this doesn't seem right...
          #  LEN
          else
            raise "Unknown wire type for field #{field.type}"
          end
        end
      end
    end
  end
end
