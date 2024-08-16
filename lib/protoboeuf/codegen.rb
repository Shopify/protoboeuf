# frozen_string_literal: true

require "erb"
require "syntax_tree"
require_relative "codegen_type_helper"

module ProtoBoeuf
  class CodeGen
    class EnumCompiler
      attr_reader :generate_types
      include TypeHelper

      def self.result(enum, generate_types:)
        new(enum, generate_types:).result
      end

      attr_reader :enum

      def initialize(enum, generate_types:)
        @enum = enum
        @generate_types = generate_types
      end

      def result
        "module #{enum.name}\n" + class_body + "; end\n"
      end

      private

      def class_body
        enum.value.map { |const|
          "#{const.name} = #{const.number}"
        }.join("\n") + "\n\n" + lookup + "\n\n" + resolve
      end

      def lookup
        type_signature(params: {val: "Integer"}, returns: "Symbol", newline: true) +
        "def self.lookup(val)\n" +
        "if " + enum.value.map { |const|
          "val == #{const.number} then :#{const.name}"
        }.join(" elsif ") + " end; end"
      end

      def resolve
        type_signature(params: {val: "Symbol"}, returns: "Integer", newline: true) +
        "def self.resolve(val)\n" +
        "if " + enum.value.map { |const|
          "val == :#{const.name} then #{const.number}"
        }.join(" elsif ") + " end; end"
      end
    end

    class MessageCompiler
      attr_reader :generate_types

      include TypeHelper

      def self.result(message, toplevel_enums, generate_types:)
        new(message, toplevel_enums, generate_types:).result
      end

      attr_reader :message, :fields, :oneof_fields
      attr_reader :optional_fields, :enum_field_types

      def initialize(message, toplevel_enums, generate_types:)
        @message = message
        @optional_field_bit_lut = []
        @fields = @message.field
        @enum_field_types = toplevel_enums.merge(message.enum_type.group_by(&:name))
        @requires = Set.new
        @generate_types = generate_types
        @has_submessage = false

        @required_fields = []
        @optional_fields = []
        @oneof_fields = []
        @enum_fields = []
        @oneof_selection_fields = []

        message.field.each { |field|
          if field.has_oneof_index? && !field.proto3_optional
            (@oneof_fields[field.oneof_index] ||= []) << field
          else
            if field.proto3_optional
              @optional_fields << field
            else
              if field.type == :TYPE_ENUM
                @enum_fields << field
              else
                @required_fields << field
              end
            end
          end
        }

        # The AST treats "optional" fields in Proto3 as "oneof" fields.
        # But since there is only one of each of these "oneof" fields, there
        # is no reason to add an extra instance variable.  The "oneof_fields"
        # list only contains non-proto3_optional fields, so we're using that
        # to only iterate over actual "oneof" fields.
        @oneof_selection_fields = @oneof_fields.each_with_index.map { |item, i|
          item && message.oneof_decl[i]
        }

        @optional_fields.each_with_index { |field, i|
          @optional_field_bit_lut[field.number] = i
        }
      end

      def result
        body = "class #{message.name}\n" + class_body + "end\n"
        if @requires.empty?
          body
        else
          @requires.map { |r| "require #{r.dump}" }.join("\n") + "\n\n" + body
        end
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
        fields = self.fields.reject { |field|
          field.has_oneof_index? && !field.proto3_optional
        }

        oneofs = @oneof_selection_fields.map { |field|
          "send(#{field.name.dump}).tap { |f| result[f.to_sym] = send(f) if f }"
        }

        <<~RUBY
          #{type_signature(returns: "T::Hash[Symbol, T.untyped]")}
          def to_h
            result = {}
            #{(oneofs + fields.map { |field| convert_field(field) }).join("\n")}
            result
          end
        RUBY
      end

      def convert_field(field)
        if repeated?(field)
          "result['#{field.name}'.to_sym] = #{iv_name(field)}"
        elsif field.type == :TYPE_MESSAGE
          "result['#{field.name}'.to_sym] = #{iv_name(field)}.to_h"
        else
          "result['#{field.name}'.to_sym] = #{iv_name(field)}"
        end
      end

      def encode
        # FIXME: we should probably sort fields by field number
        type_signature(params: {buff: "String"}, returns: "String", newline: true) +
        "def _encode(buff)\n" +
          fields.map { |field| encode_subtype(field) }.compact.join("\n") +
          "\nbuff\n end\n\n"
      end

      def encode_subtype(field, value_expr = iv_name(field), tagged = true)
        if field.label == :LABEL_REPEATED
          if map_field?(field)
            encode_map(field, value_expr, tagged)
          else
            encode_repeated(field, value_expr, tagged)
          end
        else
          encode_leaf_type(field, value_expr, tagged)
        end
      end

      def encode_leaf_type(field, value_expr, tagged)
        send "encode_#{field.type.to_s.downcase.delete_prefix("type_")}", field, value_expr, tagged
      end

      def encode_tag(field)
        tag = (field.number << 3) | CodeGen.wire_type(field)
        "buff << #{sprintf("%#04x", tag)}\n"
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

      def encode_bytes(field, value_expr, tagged)
        # Empty bytes is default value, so encodes nothing
        <<~RUBY
          val = #{value_expr}
          if((bs = val.bytesize) > 0)
            #{encode_tag_and_length(field, tagged, "bs")}
            buff.concat(val.b)
          end
        RUBY
      end

      def encode_enum(field, value_expr, tagged)
        # Zero is default value for enums, so encodes nothing
        <<~RUBY
          val = #{value_expr}
          if val != 0
            #{encode_tag_and_length(field, tagged)}
            #{uint64_code("val")}
          end
        RUBY
      end

      def encode_map(field, value_expr, tagged)
        map_type = self.map_type(field)

        <<~RUBY
          map = #{value_expr}
          if map.size > 0
            old_buff = buff
            map.each do |key, value|
              buff = new_buffer = +''
              #{encode_subtype(map_type.field[0], "key", true)}
              #{encode_subtype(map_type.field[1], "value", true)}
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
            if #{iv_name(field)} == :"#{f.name}"
              #{encode_subtype(f, iv_name(f))}
            end
          RUBY
        end.join("\n")
      end

      def encode_repeated(field, value_expr, tagged)
        <<~RUBY
          list = #{value_expr}
          if list.size > 0
            #{encode_tag_and_length(field, CodeGen.packed?(field), "list.size")}
            list.each do |item|
              #{encode_leaf_type(field, "item", !CodeGen.packed?(field))}
            end
          end
        RUBY
      end

      def encode_string(field, value_expr, tagged)
        # Empty string is default value, so encodes nothing
        <<~RUBY
          val = #{value_expr}
          if((len = val.bytesize) > 0)
            #{encode_tag_and_length(field, tagged, "len")}
            buff << (val.ascii_only? ? val : val.b)
          end
        RUBY
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
      alias encode_uint32 encode_uint64

      def encode_int64(field, value_expr, tagged)
        # Zero is the default value, so it encodes zero bytes
        <<~RUBY
          val = #{value_expr}
          if val != 0
            #{encode_tag_and_length(field, tagged)}
            while val != 0
              byte = val & 0x7F

              val >>= 7
              # This drops the top bits,
              # Otherwise, with a signed right shift,
              # we get infinity one bits at the top
              val &= (1 << 57) - 1

              byte |= 0x80 if val != 0
              buff << byte
            end
          end
        RUBY
      end

      # The same encoding logic is used for int32 and int64
      alias encode_int32 encode_int64

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
      alias encode_sint32 encode_sint64

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
          #{type_signature(params: {buff: "String"}, returns: message.name)}
          def self.decode(buff)
            allocate.decode_from(buff.b, 0, buff.bytesize)
          end

          #{type_signature(params: {obj: message.name}, returns: "String")}
          def self.encode(obj)
            obj._encode("".b)
          end
        RUBY
      end

      def enums
        message.enum_type.map { |enum|
          EnumCompiler.result(enum, generate_types:)
        }.join("\n")
      end

      def constants
        message.nested_type.reject { |x| x.options&.map_entry }.map { |x|
          self.class.new(x, enum_field_types, generate_types:).result
        }.join("\n")
      end

      def readers
        required_readers + enum_readers + optional_readers + oneof_readers
      end

      def enum_readers
        fields = @enum_fields
        return "" if fields.empty?

        "  # enum readers\n" +
          fields.map { |field|
            "def #{field.name}; #{class_name(field)}.lookup(#{iv_name(field)}) || #{iv_name(field)}; end"
          }.join("\n") + "\n"
      end

      def class_name(field)
        field.type_name.delete_prefix(".").gsub(".", "::")
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
        return "" unless optional_fields.length > 0

        "# optional field readers\n" +
        optional_fields.map do |field|
          "#{reader_type_signature(field)}\nattr_reader :#{field.name}\n"
        end.join("\n") +
        "\n\n"
      end

      def oneof_readers
        return "" unless oneof_fields.length > 0

        "# oneof field readers\n" +
        oneof_fields.map.with_index do |sub_fields, i|
          next unless sub_fields

          field = message.oneof_decl[i]

          [
            type_signature(returns: "Symbol"),
            "attr_reader :#{field.name}",
            sub_fields.map do |sub_field|
              "#{reader_type_signature(sub_field)}\nattr_reader :#{sub_field.name}"
            end
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
          fields.map { |field|
            "def #{field.name}=(v); #{iv_name(field)} = #{class_name(field)}.resolve(v) || v; end"
          }.join("\n") + "\n\n"
      end

      def required_writers
        fields = @required_fields

        return "" if fields.empty?

        fields.map { |field|
          <<~RUBY
            #{type_signature(params: {v: convert_field_type(field)})}
            def #{field.name}=(v)
              #{bounds_check(field, "v")}
              #{iv_name(field)} = v
            end
          RUBY
        }.join("\n") + "\n"
      end

      def optional_writers
        return "" if optional_fields.empty?

        "# BEGIN writers for optional fields\n" +
        optional_fields.map { |field|
          <<~RUBY
            #{type_signature(params: {v: convert_field_type(field)})}
            def #{field.name}=(v)
              #{bounds_check(field, "v")}
              #{set_bitmask(field)}
              #{iv_name(field)} = v
            end
          RUBY
        }.join("\n") +
        "  # END writers for optional fields\n\n"
      end

      def oneof_writers
        return "" if oneof_fields.empty?

        "# BEGIN writers for oneof fields\n" +
        oneof_fields.map.with_index { |sub_fields, i|
          next unless sub_fields

          oneof = message.oneof_decl[i]
          sub_fields.map { |field|
            <<~RUBY
              def #{field.name}=(v)
                #{bounds_check(field, "v")}
                @#{oneof.name} = :#{field.name}
                #{iv_name(field)} = v
              end
            RUBY
          }.join("\n")
        }.join("\n") +
        "# END writers for oneof fields\n\n"
      end

      def initialize_code
        initialize_type_signature(fields) +
          "def initialize(" + initialize_signature + ")\n" +
          init_bitmask(message) +
          initialize_oneofs +
          fields.map { |field|
            if field.has_oneof_index? && !field.proto3_optional
              initialize_oneof(field, message)
            else
              initialize_field(field)
            end
          }.join("\n") + "\nend\n\n"
      end

      def initialize_oneofs
        @oneof_selection_fields.map { |field|
          "#{iv_name(field)} = nil # oneof field"
        }.join("\n") + "\n"
      end

      def initialize_oneof(field, msg)
        oneof = msg.oneof_decl[field.oneof_index]

        <<~RUBY
              if #{lvar_read(field)} == nil
                #{iv_name(field)} = #{default_for(field)}
              else
                #{bounds_check(field, lvar_read(field))}
                #{iv_name(oneof)} = :#{field.name}
                #{iv_name(field)} = #{lvar_read(field)}
              end
        RUBY
      end

      def initialize_field(field)
        if field.label == :LABEL_OPTIONAL && field.proto3_optional
          initialize_optional_field(field)
        elsif field.type == :TYPE_ENUM
          initialize_enum_field(field)
        else
          initialize_required_field(field)
        end
      end

      def initialize_optional_field(field)
        <<~RUBY
          if #{lvar_read(field)} == nil
            #{iv_name(field)} = #{default_for(field)}
          else
            #{bounds_check(field, lvar_read(field)).chomp}
            #{set_bitmask(field)}
            #{iv_name(field)} = #{lvar_read(field)}
          end
        RUBY
      end

      RUBY_KEYWORDS = %w{ __ENCODING__ __LINE__ __FILE__ BEGIN END alias and
      begin break case class def defined?  do else elsif end ensure false for if
      in module next nil not or redo rescue retry return self super then true
      undef unless until when while yield }.to_set

      # Return code for reading the local variable returned by `lvar_name`
      def lvar_read(field)
        if RUBY_KEYWORDS.include?(field.name)
          "binding.local_variable_get(:#{field.name})"
        else
          if field.name =~ /^[A-Z_]/
            "_#{field.name}"
          else
            field.name
          end
        end
      end

      def lvar_name(field)
        if RUBY_KEYWORDS.include?(field.name)
          field.name
        else
          if field.name =~ /^[A-Z_]/
            "_#{field.name}"
          else
            field.name
          end
        end
      end

      # Return an instance variable name for use in generated code
      def iv_name(field)
        "@#{field.name}"
      end

      def initialize_required_field(field)
        <<~RUBY
          #{bounds_check(field, lvar_read(field)).chomp}
          #{iv_name(field)} = #{lvar_read(field)}
        RUBY
      end

      def initialize_enum_field(field)
        "#{iv_name(field)} = #{class_name(field)}.resolve(#{field.name}) || #{lvar_read(field)}"
      end

      def extra_api
        optional_predicates
      end

      def optional_predicates
        return "" unless optional_fields.length > 0

        optional_fields.map { |field|
          <<~RUBY
            #{type_signature(returns: "T::Boolean")}
            def has_#{field.name}?
              #{test_bitmask(field)}
            end
          RUBY
        }.join("\n") + "\n"
      end

      def decode
        type_signature(params: {buff: String, index: Integer, len: Integer}, returns: message.name, newline: true) +
          DECODE_METHOD.result(binding)
      end

      def oneof_field_readers
        fields = oneof_fields + oneof_fields.flat_map(&:fields)
        return "" if fields.empty?
        "attr_reader " + fields.map { |f| ":" + f.name }.join(", ")
      end

      TYPE_BOUNDS = {
        :TYPE_UINT32 => [0, 4_294_967_295],
        :TYPE_INT32 => [-2_147_483_648,  2_147_483_647],
        :TYPE_SINT32 => [-2_147_483_648,  2_147_483_647],
        :TYPE_UINT64 => [0, 18_446_744_073_709_551_615],
        :TYPE_INT64 => [-9_223_372_036_854_775_808, 9_223_372_036_854_775_807],
        :TYPE_SINT64 => [-9_223_372_036_854_775_808, 9_223_372_036_854_775_807],
      }.freeze

      PULL_VARINT = ERB.new(<<~ERB, trim_mode: '-')
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

      PULL_STRING = ERB.new(<<~ERB, trim_mode: '-')
        value = <%= pull_varint %>

        <%= dest %> <%= operator %> buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
        index += value
      ERB

      PULL_BYTES = ERB.new(<<~ERB, trim_mode: '-')
        value = <%= pull_varint %>

        <%= dest %> <%= operator %> buff.byteslice(index, value)
        index += value
      ERB

      PULL_SINT32 = ERB.new(<<~ERB, trim_mode: '-')
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

      DECODE_METHOD = ERB.new(<<~ERB, trim_mode: '-')
        def decode_from(buff, index, len)
          <%= init_bitmask(message) %>
          <%- for field in @oneof_selection_fields -%>
            <%= iv_name(field) %> = nil # oneof field
          <%- end -%>
          <%- for field in fields -%>
            <%= iv_name(field) %> = <%= default_for(field) %>
          <%- end -%>

          <%- unless fields.empty? -%>
          <%= pull_tag %>
          <%- end -%>

          while true
            <%- fields.each do |field| -%>
              <%- if !field.has_oneof_index? || field.proto3_optional -%>
            if tag == <%= tag_for_field(field, field.number) %>
              <%= decode_code(field) %>
              <%= set_bitmask(field) if field.proto3_optional %>
              return self if index >= len
              <%- if !reads_next_tag?(field) -%>
              <%= pull_tag %>
              <%- end -%>
            end
              <%- else -%>
            if tag == <%= tag_for_field(field, field.number) %>
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
        list = <%= iv_name(field) %>
        while true
          break if index >= goal
          <%= decode_subtype(field, field.type, "list", "<<") %>
        end
      ERB

      def pull_tag
        str = <<~RUBY
          tag = buff.getbyte(index)
          index += 1
        RUBY

        if $DEBUG
          str += <<~'RUBY'
            puts "reading field #{tag >> 3} type: #{tag & 0x7} #{tag}"
          RUBY
        end

        str
      end

      def default_for(field)
        if field.label == :LABEL_REPEATED
          if map_field?(field)
            '{}'
          else
            '[]'
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
            'nil'
          else
            raise NotImplementedError, field.type.to_s
          end
        end
      end

      def map_field?(field)
        return false unless field.label == :LABEL_REPEATED
        map_name = field.type_name.split(".").last
        message.nested_type.any? { |type| type.name == map_name && type.options&.map_entry }
      end

      def map_type(field)
        return false unless field.label == :LABEL_REPEATED
        map_name = field.type_name.split(".").last
        message.nested_type.find { |type|
          type.name == map_name && type.options&.map_entry
        } || raise(ArgumentError, "Not a map field")
      end

      def initialize_signature
        self.fields.flat_map { |f|
          if f.has_oneof_index? && !f.proto3_optional
            "#{lvar_name(f)}: nil"
          else
            if f.proto3_optional
              "#{lvar_name(f)}: nil"
            else
              "#{lvar_name(f)}: #{default_for(f)}"
            end
          end
        }.join(", ")
      end

      def tag_for_field(field, idx)
        sprintf("%#02x", (idx << 3 | CodeGen.wire_type(field)))
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
              pull_message(field.type_name.sub(/^\./, '').gsub(".", "::"), dest, operator)
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
        "#{dest} #{operator} (" + 8.times.map { |i| "(buff.getbyte(index + #{i}) << #{i * 8})" }.join(" | ") + "); index += 8"
      end

      def pull_fixed_int32(dest, operator)
        "#{dest} #{operator} (" + 4.times.map { |i| "(buff.getbyte(index + #{i}) << #{i * 8})" }.join(" | ") + "); index += 4"
      end

      def decode_map(field)
        map_type = self.map_type(field)

        <<~RUBY
          ## PULL_MAP
          map = #{iv_name(field)}
          while tag == #{tag_for_field(field, field.number)}
            #{pull_uint64("value", "=")}
            index += 1 # skip the tag, assume it's the key
            #{decode_subtype(map_type.field[0], map_type.field[0].type, "key", "=")}
            index += 1 # skip the tag, assume it's the value
            #{decode_subtype(map_type.field[1], map_type.field[1].type, "map[key]", "=")}
            return self if index >= len
            #{pull_tag}
          end
        RUBY
      end

      def decode_repeated(field)
        <<~RUBY
          ## DECODE REPEATED
          list = #{iv_name(field)}
          while true
            #{decode_subtype(field, field.type, "list", "<<")}
            #{pull_tag}
            break unless tag == #{tag_for_field(field, field.number)}
          end
          ## END DECODE REPEATED
        RUBY
      end

      def pull_message(type, dest, operator)
        if type == ".google.protobuf.BoolValue"
          @requires << "protoboeuf/protobuf/boolvalue"
          type = "ProtoBoeuf::Protobuf::BoolValue"
        end

        if type == ".google.protobuf.Int32Value"
          @requires << "protoboeuf/protobuf/int32value"
          type = "ProtoBoeuf::Protobuf::Int32Value"
        end

        if type == ".google.protobuf.Int64Value"
          @requires << "protoboeuf/protobuf/int64value"
          type = "ProtoBoeuf::Protobuf::Int64Value"
        end

        if type == ".google.protobuf.UInt32Value"
          @requires << "protoboeuf/protobuf/uint32value"
          type = "ProtoBoeuf::Protobuf::UInt32Value"
        end

        if type == ".google.protobuf.UInt64Value"
          @requires << "protoboeuf/protobuf/uint64value"
          type = "ProtoBoeuf::Protobuf::UInt64Value"
        end

        if type == ".google.protobuf.FloatValue"
          @requires << "protoboeuf/protobuf/floatvalue"
          type = "ProtoBoeuf::Protobuf::FloatValue"
        end

        if type == ".google.protobuf.DoubleValue"
          @requires << "protoboeuf/protobuf/doublevalue"
          type = "ProtoBoeuf::Protobuf::DoubleValue"
        end

        if type == ".google.protobuf.StringValue"
          @requires << "protoboeuf/protobuf/stringvalue"
          type = "ProtoBoeuf::Protobuf::StringValue"
        end

        if type == ".google.protobuf.BytesValue"
          @requires << "protoboeuf/protobuf/bytesvalue"
          type = "ProtoBoeuf::Protobuf::BytesValue"
        end

        if type == ".google.protobuf.Timestamp"
          @requires << "protoboeuf/protobuf/timestamp"
          type = "ProtoBoeuf::Protobuf::Timestamp"
        end

        if type == ".google.protobuf.Any"
          @requires << "protoboeuf/protobuf/any"
          type = "ProtoBoeuf::Protobuf::Any"
        end

        if type == ".google.protobuf.Duration"
          @requires << "protoboeuf/protobuf/duration"
          type = "ProtoBoeuf::Protobuf::Duration"
        end

        <<~RUBY
          ## PULL_MESSAGE
          #{pull_uint64("msg_len", "=")}
          #{dest} #{operator} #{type}.allocate.decode_from(buff, index, index += msg_len)
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

      alias :pull_sint64 :pull_sint32

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

      alias :pull_uint32 :pull_uint64

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
          if map_field?(field)
            decode_map(field)
          else
            if CodeGen.packed?(field)
              PACKED_REPEATED.result(binding)
            else
              decode_repeated(field)
            end
          end
        else
          decode_subtype(field, field.type, iv_name(field), "=")
        end
      end

      def required_fields(msg)
        msg.fields.select(&:field?).reject(&:optional?)
      end

      def init_bitmask(msg)
        optionals = optional_fields
        raise NotImplementedError unless optionals.length < 63
        if optionals.length > 0
          "    @_bitmask = 0\n\n"
        else
          ""
        end
      end

      def set_bitmask(field)
        i = @optional_field_bit_lut[field.number]
        "@_bitmask |= #{sprintf("%#018x", 1 << i)}"
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
        i = @optional_field_bit_lut[field.number]
        "(@_bitmask & #{sprintf("%#018x", 1 << i)}) == #{sprintf("%#018x", 1 << i)}"
      end

      def reads_next_tag?(field)
        map_field?(field) || (repeated?(field) && !CodeGen.packed?(field))
      end

      def repeated?(field)
        field.label == :LABEL_REPEATED
      end
    end

    attr_reader :generate_types

    def initialize(ast, generate_types: false)
      @ast = ast # unit node
      @generate_types = generate_types
    end

    def to_ruby
      @ast.file.each do |file|
        modules = resolve_modules(file)
        head = "# encoding: ascii-8bit\n"
        head += "# typed: false\n" if generate_types
        head += "# frozen_string_literal: true\n\n"
        head += modules.map { |m| "module #{m}\n" }.join

        toplevel_enums = file.enum_type.group_by(&:name)
        body = file.enum_type.map { |enum| EnumCompiler.result(enum, generate_types:) }.join + "\n"
        body += file.message_type.map { |message| MessageCompiler.result(message, toplevel_enums, generate_types:) }.join

        tail = "\n" + modules.map { "end" }.join("\n")

        #puts head + body + tail
        return SyntaxTree.format(head + body + tail)
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

    PACKED_TYPES = %i{ TYPE_DOUBLE TYPE_FLOAT TYPE_INT32 TYPE_INT64 TYPE_UINT32
    TYPE_UINT64 TYPE_SINT32 TYPE_SINT64 TYPE_FIXED32 TYPE_FIXED64 TYPE_SFIXED32
    TYPE_SFIXED64 TYPE_BOOL }.to_set.freeze

    # Returns whether or not a repeated field is packed.
    # In Proto3 documents, repeated fields default to packed
    def self.packed?(field)
      raise ArgumentError unless field.label == :LABEL_REPEATED

      return PACKED_TYPES.include?(field.type) unless field.options

      field.options.packed
    end

    def self.wire_type(field)
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
        #when /[A-Z]+\w+/ # FIXME: this doesn't seem right...
        #  LEN
        else
          raise "Unknown wire type for field #{field.type}"
        end
      end
    end
  end
end
