# frozen_string_literal: true

require "erb"
require "syntax_tree"

module ProtoBoeuf
  class CodeGen
    class EnumCompiler
      def self.result(enum)
        new(enum).result
      end

      attr_reader :enum

      def initialize(enum)
        @enum = enum
      end

      def result
        "module #{enum.name}\n" + class_body + "; end\n"
      end

      private

      def class_body
        enum.constants.map { |const|
          "#{const.name} = #{const.number}"
        }.join("\n") + "\n" + lookup + "\n" + resolve
      end

      def lookup
        "def self.lookup(val)\n" +
        "if " + enum.constants.map { |const|
          "val == #{const.number} then :#{const.name}"
        }.join(" elsif ") + " end; end"
      end

      def resolve
        "def self.resolve(val)\n" +
        "if " + enum.constants.map { |const|
          "val == :#{const.name} then #{const.number}"
        }.join(" elsif ") + " end; end"
      end
    end

    class MessageCompiler
      def self.result(message, toplevel_enums)
        new(message, toplevel_enums).result
      end

      attr_reader :message, :fields, :oneof_fields
      attr_reader :optional_fields, :enum_field_types

      def initialize(message, toplevel_enums)
        @message = message
        @optional_field_bit_lut = []
        @fields = @message.fields
        @enum_field_types = toplevel_enums.merge(message.enums.group_by(&:name))
        @requires = Set.new

        mark_enum_fields

        field_types = message.fields.group_by { |field|
          if field.field?
            field.qualifier || :required
          else
            :oneof
          end
        }

        @required_fields = field_types[:required] || []
        @optional_fields = field_types[:optional] || []
        @oneof_fields = field_types[:oneof] || []

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

      def mark_enum_fields
        message.fields.select { |field| field.field? && enum_field_types.key?(field.type) }.each do |field|
          field.enum = true
        end
      end

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
        <<~RUBY
          def to_h
            result = {}
            #{fields.map { |field| "result['#{field.name}'.to_sym] = @#{field.name}" }.join("\n")}
            result
          end
        RUBY
      end

      def encode
        # FIXME: we should probably sort fields by field number
        "def _encode\n  buff = ''.b\n" +
          fields.map { |field| encode_subtype(field) }.compact.join("\n") +
        "\n  buff\nend\n"
      end

      def encode_subtype(field, value_expr = "@#{field.name}", tagged = true)
        return unless field.field?

        method = if field.repeated?
          "encode_repeated"
        elsif field.enum?
          "encode_enum"
        elsif field.scalar?
          "encode_#{field.type}"
        else
          # FIXME: we need to support all types
          return
        end

        send(method, field, value_expr, tagged) if respond_to?(method, true)
      end

      def encode_tag_and_length(field, tagged, len_expr = false)
        result = +""

        if tagged
          tag = (field.number << 3) | field.wire_type
          result << "buff << #{sprintf("%#04x", tag)}\n"

          if field.wire_type == ProtoBoeuf::Field::LEN
            raise "length encoded fields must have a length expression" unless len_expr

            result << <<~RUBY
              len = #{len_expr}
              while len > 0
                byte = len & 0x7F
                len >>= 7
                byte |= 0x80 if len > 0
                buff << byte
              end
            RUBY
          end
        end

        result
      end

      def encode_bool(field, value_expr, tagged)
        # False/zero is the default value, so the false case encodes nothing
        <<~RUBY
          val = #{value_expr}
          if val == true
\            #{encode_tag_and_length(field, tagged)}
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
          val = #{value_expr}.b
          if val.bytesize > 0
            #{encode_tag_and_length(field, tagged, "val.bytesize")}
            buff.concat(val)
          end
        RUBY
      end

      def encode_enum(field, value_expr, tagged)
        # Zero is default value for enums, so encodes nothing
        <<~RUBY
          val = #{value_expr}
          if val != 0
            #{encode_tag_and_length(field, tagged)}
            while val > 0
              byte = val & 0x7F
              val >>= 7
              byte |= 0x80 if val > 0
              buff << byte
            end
          end
        RUBY
      end

      def encode_repeated(field, value_expr, tagged)
        <<~RUBY
          list = #{value_expr}
          if list.size > 0
            #{encode_tag_and_length(field, field.packed?, "list.size")}
            list.each do |item|
              #{encode_subtype(field.item_field, "item", !field.packed?)}
            end
          end
        RUBY
      end

      def encode_string(field, value_expr, tagged)
        # Empty string is default value, so encodes nothing
        <<~RUBY
          val = #{value_expr}.encode(Encoding::UTF_8).b
          if val.bytesize > 0
            #{encode_tag_and_length(field, tagged, "val.bytesize")}
            buff.concat(val)
          end
        RUBY
      end

      def encode_uint64(field, value_expr, tagged)
        # Zero is the default value, so it encodes zero bytes
        <<~RUBY
          val = #{value_expr}
          if val != 0
            #{encode_tag_and_length(field, tagged)}
            while val != 0
              byte = val & 0x7F
              val >>= 7
              byte |= 0x80 if val > 0
              buff << byte
            end
          end
        RUBY
      end

      # NOTE: should we be doing bounds checking somewhere?
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

          while val > 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
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
          buff << [val].pack('D')
        end
        eocode
      end

      def encode_float(field, value_expr, tagged)
        # False/zero is the default value, so the zero case encodes nothing
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}
          buff << [val].pack('F')
        end
        eocode
      end

      def encode_fixed64(field, value_expr, tagged)
        # False/zero is the default value, so the zero case encodes nothing
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}
          buff << [val].pack('Q<')
        end
        eocode
      end

      def encode_sfixed64(field, value_expr, tagged)
        # False/zero is the default value, so the zero case encodes nothing
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}
          buff << [val].pack('q<')
        end
        eocode
      end

      def encode_fixed32(field, value_expr, tagged)
        # False/zero is the default value, so the zero case encodes nothing
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}
          buff << [val].pack('L<')
        end
        eocode
      end

      def encode_sfixed32(field, value_expr, tagged)
        # False/zero is the default value, so the zero case encodes nothing
        <<-eocode
        val = #{value_expr}
        if val != 0
          #{encode_tag_and_length(field, tagged)}
          buff << [val].pack('l<')
        end
        eocode
      end

      def prelude
        <<~RUBY
          def self.decode(buff)
            buff = buff.b
            allocate.decode_from(buff, 0, buff.bytesize)
          end

          def self.encode(obj)
            obj._encode
          end
        RUBY
      end

      def enums
        message.enums.map { |enum|
          EnumCompiler.result(enum)
        }.join("\n")
      end

      def constants
        (if message.fields.any? { |msg| msg.oneof? || msg.optional? }
          <<~RUBY
            NONE = Object.new
            private_constant :NONE

          RUBY
        else
          ""
        end) + message.messages.map { |x| self.class.new(x, enum_field_types).result }.join("\n")
      end

      def readers
        required_readers + enum_readers + optional_readers + oneof_readers
      end

      def enum_readers
        fields = message.fields.select { |field| field.field? && field.enum? }
        return "" if fields.empty?

        "  # enum readers\n" +
          fields.map { |field|
            "def #{field.name}; #{field.type}.lookup(@#{field.name}) || @#{field.name}; end"
          }.join("\n") + "\n"
      end

      def required_readers
        fields = message.fields.select(&:field?).reject(&:optional?).reject(&:enum?)
        return "" if fields.empty?

        "# required field readers\n" +
        "attr_accessor " + fields.map { |f| ":" + f.name }.join(", ") + "\n\n"
      end

      def optional_readers
        return "" unless optional_fields.length > 0
        "# optional field readers\n" +
        "attr_reader " + optional_fields.map { |f| ":" + f.name }.join(", ") + "\n\n"
      end

      def oneof_readers
        return "" unless oneof_fields.length > 0
        fields = oneof_fields + oneof_fields.flat_map(&:fields)

        "# oneof field readers\n" +
        "attr_reader " + fields.map { |f| ":" + f.name }.join(", ") + "\n\n"
      end

      def writers
        required_writers + enum_writers + optional_writers + oneof_writers
      end

      def enum_writers
        fields = message.fields.select { |field| field.field? && field.enum? }
        return "" if fields.empty?

        "# enum writers\n" +
          fields.map { |field|
            "def #{field.name}=(v); @#{field.name} = #{field.type}.resolve(v) || v; end"
          }.join("\n") + "\n\n"
      end

      def required_writers
        # We generate attr_accessors for required fields, so no need for writers
        ""
      end

      def optional_writers
        return "" if optional_fields.empty?

        "# BEGIN writers for optional fields\n" +
        optional_fields.map { |field|
          <<~RUBY
            def #{field.name}=(v)
              #{set_bitmask(field)}
              @#{field.name} = v
            end
          RUBY
        }.join("\n") +
        "  # END writers for optional fields\n\n"
      end

      def oneof_writers
        return "" if oneof_fields.empty?

        "# BEGIN writers for oneof fields\n" +
        oneof_fields.map { |oneof|
          oneof.fields.map { |field|
            <<~RUBY
              def #{field.name}=(v)
                @#{oneof.name} = :#{field.name}
                @#{field.name} = v
              end
            RUBY
          }.join("\n")
        }.join("\n") +
        "# END writers for oneof fields\n\n"
      end

      def initialize_code
        "def initialize(" + initialize_signature + ")\n" +
          init_bitmask(message) +
          fields.map { |field|
            if field.field?
              initialize_field(field)
            elsif field.oneof?
              initialize_oneof(field)
            else
              raise field.inspect
            end
          }.join("\n") + "\nend\n\n"
      end

      def initialize_oneof(oneof)
        "@#{oneof.name} = nil # oneof field\n" +
          oneof.fields.map { |field|
            <<~RUBY
              if #{field.name} == NONE
                @#{field.name} = #{default_for(field)}
              else
                @#{oneof.name} = :#{field.name}
                @#{field.name} = #{field.name}
              end
            RUBY
          }.join("\n")
      end

      def initialize_field(field)
        if field.optional?
          initialize_optional_field(field)
        elsif field.field? && field.enum?
          initialize_enum_field(field)
        else
          initialize_required_field(field)
        end
      end

      def initialize_optional_field(field)
        <<~RUBY
          if #{field.name} == NONE
            @#{field.name} = #{default_for(field)}
          else
            #{set_bitmask(field)}
            @#{field.name} = #{field.name}
          end
        RUBY
      end

      def initialize_required_field(field)
        "@#{field.name} = #{field.name}"
      end

      def initialize_enum_field(field)
        "@#{field.name} = #{field.type}.resolve(#{field.name}) || #{field.name}"
      end

      def extra_api
        optional_predicates
      end

      def optional_predicates
        return "" unless optional_fields.length > 0

        optional_fields.map { |field|
          <<~RUBY
            def has_#{field.name}?
              #{test_bitmask(field)}
            end
          RUBY
        }.join("\n") + "\n"
      end

      def decode
        DECODE_METHOD.result(binding)
      end

      def oneof_field_readers
        fields = oneof_fields + oneof_fields.flat_map(&:fields)
        return "" if fields.empty?
        "attr_reader " + fields.map { |f| ":" + f.name }.join(", ")
      end

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

        <%= dest %> <%= operator %> buff.byteslice(index, value)
        index += value
      ERB

      PULL_BYTES = ERB.new(<<~ERB, trim_mode: '-')
        value = <%= pull_varint %>

        <%= dest %> <%= operator %> buff.byteslice(index, value).force_encoding(Encoding::ASCII_8BIT)
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
          <%- for field in fields -%>
            <%- if field.field? -%>
            @<%= field.name %> = <%= default_for(field) %>
            <%- else -%>
            @<%= field.name %> = nil # oneof field
              <%- for oneof_child in field.fields -%>
            @<%= oneof_child.name %> = <%= default_for(oneof_child) %>
              <%- end -%>
            <%- end -%>
          <%- end -%>

          <%- unless fields.empty? -%>
          <%= pull_tag %>
          <%- end -%>

          while true
            <%- fields.each do |field| -%>
              <%- if field.field? -%>
            if tag == <%= tag_for_field(field, field.number) %>
              <%= decode_code(field) %>
              <%= set_bitmask(field) if field.optional? %>
              return self if index >= len
              <%- if !field.reads_next_tag? -%>
              <%= pull_tag %>
              <%- end -%>
            end
              <%- else -%>
                <%- field.fields.each do |child| -%>
            if tag == <%= tag_for_field(child, child.number) %>
              <%= decode_code(child) %>
              @<%= field.name %> = :<%= child.name %>
              return self if index >= len
              <%= pull_tag %>
            end
                <%- end -%>
              <%- end -%>
            <%- end -%>

            return self if index >= len
            raise NotImplementedError
          end
        end
      ERB

      PACKED_REPEATED = ERB.new(<<~ERB)
        <%= pull_uint64("value", "=") %>
        goal = index + value
        list = @<%= field.name %>
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
        if field.field?
          if field.repeated?
            "[]"
          else
            if field.enum?
              0
            else
              case field.type
              when "string", "bytes"
                '""'
              when "uint64", "int32", "sint32", "uint32", "int64", "sint64", "fixed64", "fixed32", "sfixed64", "sfixed32"
                0
              when "double", "float"
                0.0
              when "bool"
                false
              when /[A-Z]+\w+/ # FIXME: this doesn't seem right...
                'nil'
              when MapType
                "{}"
              else
                raise "Unknown field type #{field.type}"
              end
            end
          end
        elsif field.map?
          "{}"
        else
          'nil'
        end
      end

      def initialize_signature
        self.fields.flat_map { |f|
          if f.field?
            if f.optional?
              "#{f.name}: NONE"
            else
              "#{f.name}: #{default_for(f)}"
            end
          elsif f.oneof?
            f.fields.map { |child|
              "#{child.name}: NONE"
            }
          else
            raise NotImplementedError
          end
        }.join(", ")
      end

      def tag_for_field(field, idx)
        sprintf("%#02x", (idx << 3 | wire_type(field)))
      end

      def wire_type(field)
        if field.enum?
          ProtoBoeuf::Field::VARINT
        else
          field.wire_type
        end
      end

      def decode_subtype(field, type, dest, operator)
        if field.enum?
          pull_int64(dest, operator)
        else
          case type
          when "string" then pull_string(dest, operator)
          when "bytes" then pull_bytes(dest, operator)
          when "uint64" then pull_uint64(dest, operator)
          when "int64" then pull_int64(dest, operator)
          when "int32" then pull_int32(dest, operator)
          when "uint32" then pull_uint32(dest, operator)
          when "sint32" then pull_sint32(dest, operator)
          when "sint64" then pull_sint64(dest, operator)
          when "bool" then pull_boolean(dest, operator)
          when "double" then pull_double(dest, operator)
          when "fixed64" then pull_fixed_int64(dest, operator)
          when "fixed32" then pull_fixed_int32(dest, operator)
          when "sfixed64" then pull_fixed_int64(dest, operator)
          when "sfixed32" then pull_fixed_int32(dest, operator)
          when "float" then pull_float(dest, operator)
          when /[A-Z]+\w+/ # FIXME: this doesn't seem right...
            pull_message(type, dest, operator)
          else
            raise "Unknown field type #{type}"
          end
        end
      end

      def pull_double(dest, operator)
        "#{dest} #{operator} buff.byteslice(index, 8).unpack1('D'); index += 8"
      end

      def pull_float(dest, operator)
        "#{dest} #{operator} buff.byteslice(index, 4).unpack1('F'); index += 4"
      end

      def pull_fixed_int64(dest, operator)
        "#{dest} #{operator} (" + 8.times.map { |i| "(buff.getbyte(index + #{i}) << #{i * 8})" }.join(" | ") + "); index += 8"
      end

      def pull_fixed_int32(dest, operator)
        "#{dest} #{operator} (" + 4.times.map { |i| "(buff.getbyte(index + #{i}) << #{i * 8})" }.join(" | ") + "); index += 4"
      end

      def decode_map(field)
        <<~RUBY
          ## PULL_MAP
          map = @#{field.name}
          while tag == #{tag_for_field(field, field.number)}
            #{pull_uint64("value", "=")}
            index += 1 # skip the tag, assume it's the key
            #{decode_subtype(field, field.type.key_type, "key", "=")}
            index += 1 # skip the tag, assume it's the value
            #{decode_subtype(field, field.type.value_type, "map[key]", "=")}
            return self if index >= len
            #{pull_tag}
          end
        RUBY
      end

      def decode_repeated(field)
        <<~RUBY
          ## DECODE REPEATED
          list = @#{field.name}
          while true
            #{decode_subtype(field, field.type, "list", "<<")}
            #{pull_tag}
            break unless tag == #{tag_for_field(field, field.number)}
          end
          ## END DECODE REPEATED
        RUBY
      end

      def pull_message(type, dest, operator)
        if type == "google.protobuf.BoolValue"
          @requires << "protoboeuf/protobuf/boolvalue"
          type = "ProtoBoeuf::Protobuf::BoolValue"
        end

        if type == "google.protobuf.Int32Value"
          @requires << "protoboeuf/protobuf/int32value"
          type = "ProtoBoeuf::Protobuf::Int32Value"
        end

        if type == "google.protobuf.Int64Value"
          @requires << "protoboeuf/protobuf/int64value"
          type = "ProtoBoeuf::Protobuf::Int64Value"
        end

        if type == "google.protobuf.UInt32Value"
          @requires << "protoboeuf/protobuf/uint32value"
          type = "ProtoBoeuf::Protobuf::UInt32Value"
        end

        if type == "google.protobuf.UInt64Value"
          @requires << "protoboeuf/protobuf/uint64value"
          type = "ProtoBoeuf::Protobuf::UInt64Value"
        end

        if type == "google.protobuf.FloatValue"
          @requires << "protoboeuf/protobuf/floatvalue"
          type = "ProtoBoeuf::Protobuf::FloatValue"
        end

        if type == "google.protobuf.DoubleValue"
          @requires << "protoboeuf/protobuf/doublevalue"
          type = "ProtoBoeuf::Protobuf::DoubleValue"
        end

        if type == "google.protobuf.StringValue"
          @requires << "protoboeuf/protobuf/stringvalue"
          type = "ProtoBoeuf::Protobuf::StringValue"
        end

        if type == "google.protobuf.BytesValue"
          @requires << "protoboeuf/protobuf/bytesvalue"
          type = "ProtoBoeuf::Protobuf::BytesValue"
        end

        if type == "google.protobuf.Timestamp"
          @requires << "protoboeuf/protobuf/timestamp"
          type = "ProtoBoeuf::Protobuf::Timestamp"
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
        if field.repeated?
          if field.packed?
            PACKED_REPEATED.result(binding)
          else
            decode_repeated(field)
          end
        else
          if field.type.is_a?(MapType)
            decode_map(field)
          else
            decode_subtype(field, field.type, "@#{field.name}", "=")
          end
        end
      end

      def required_fields(msg)
        msg.fields.select(&:field?).reject(&:optional?)
      end

      def init_bitmask(msg)
        optionals = optional_fields
        raise NotImplementedError unless optionals.length < 63
        if optionals.length > 0
          "    @_bitmask = 0\n"
        else
          ""
        end
      end

      def set_bitmask(field)
        i = @optional_field_bit_lut[field.number]
        "@_bitmask |= #{sprintf("%#018x", 1 << i)}"
      end

      def test_bitmask(field)
        i = @optional_field_bit_lut[field.number]
        "(@_bitmask & #{sprintf("%#018x", 1 << i)}) == #{sprintf("%#018x", 1 << i)}"
      end
    end

    def initialize(ast)
      @ast = ast # unit node
    end

    def to_ruby
      packages = (@ast.package || "").split(".").reject(&:empty?)
      head = "# frozen_string_literal: true\n\n"
      head += packages.map { |m| "module " + m.split("_").map(&:capitalize).join + "\n" }.join

      toplevel_enums = @ast.enums.group_by(&:name)
      body = @ast.enums.map { |enum| EnumCompiler.result(enum) }.join + "\n"
      body += @ast.messages.map { |message| MessageCompiler.result(message, toplevel_enums) }.join

      tail = "\n" + packages.map { "end" }.join("\n")

      SyntaxTree.format(head + body + tail)
    end
  end
end
