# frozen_string_literal: true

require "erb"

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
        "def self.lookup(val) " +
        "if " + enum.constants.map { |const|
          "val == #{const.number} then :#{const.name}"
        }.join(" elsif ") + " end; end"
      end

      def resolve
        "def self.resolve(val) " +
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

      def class_body
        prelude +
          constants +
          enums +
          readers +
          writers +
          initialize_code +
          extra_api +
          decode +
          encode
      end

      def encode
        # FIXME: we should probably sort fields by field number
        "def _encode\n  buff = ''.b\n" +
          fields.map { |field|
          # FIXME: we need to support all types
          next unless field.field? && field.scalar?

          method = "encode_#{field.type}"

          send(method, field) if respond_to?(method, true)
        }.compact.join("\n") +
        "\n  buff\nend\n"
      end

      def encode_bool(field)
        tag = (field.number << 3) | field.wire_type
        # False/zero is the default value, so the false case encodes nothing
        <<-eocode
        val = @#{field.name}
        if val == true
          ## encode the tag
          buff << #{sprintf("%#04x", tag)}
          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end
        eocode
      end

      def encode_uint64(field)
        tag = (field.number << 3) | field.wire_type
        # Zero is the default value, so it encodes zero bytes
        <<-eocode
        val = @#{field.name}
        if val != 0
          ## encode the tag
          buff << #{sprintf("%#04x", tag)}
          while val > 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end
        eocode
      end

      # NOTE: should we be doing bounds checking somewhere?
      # Ideally this should happen when setting the field value?
      alias encode_uint32 encode_uint64

      def prelude
        <<-eoruby
  def self.decode(buff)
    buff = buff.dup
    buff.force_encoding(Encoding::UTF_8)
    allocate.decode_from(buff, 0, buff.bytesize)
  end

  def self.encode(obj)
    obj._encode
  end
        eoruby
      end

      def enums
        message.enums.map { |enum|
          EnumCompiler.result(enum)
        }.join("\n")
      end

      def constants
        (if message.fields.any? { |msg| msg.oneof? || msg.optional? }
          <<-eoruby
  NONE = Object.new
  private_constant :NONE

          eoruby
        else
          ""
        end) + message.messages.map { |x| self.class.new(x, enum_field_types).result }.join("\n")
      end

      def readers
        required_readers + enum_readers + optional_readers + oneof_readers
      end

      def enum?(field)
        enum_field_types.key?(field)
      end

      def enum_readers
        fields = message.fields.select { |field| field.field? && enum?(field.type) }
        "  # enum readers\n" +
          fields.map { |field|
            "def #{field.name}; #{field.type}.lookup(@#{field.name}) || @#{field.name}; end"
          }.join("\n") + "\n"
      end

      def required_readers
        fields = message.fields.select(&:field?).reject(&:optional?).reject { |field|
          enum?(field.type)
        }
        return "" unless fields.length > 0

        "  # required field readers\n" +
        "  attr_accessor " + fields.map { |f| ":" + f.name }.join(", ") + "\n\n"
      end

      def optional_readers
        return "" unless optional_fields.length > 0
        "  # optional field readers\n" +
        "  attr_reader " + optional_fields.map { |f| ":" + f.name }.join(", ") + "\n\n"
      end

      def oneof_readers
        return "" unless oneof_fields.length > 0
        fields = oneof_fields + oneof_fields.flat_map(&:fields)

        "  # oneof field readers\n" +
        "  attr_reader " + fields.map { |f| ":" + f.name }.join(", ") + "\n\n"
      end

      def writers
        required_writers + enum_writers + optional_writers + oneof_writers
      end

      def enum_writers
        fields = message.fields.select { |field| field.field? && enum?(field.type) }
        "  # enum writers\n" +
          fields.map { |field|
            "def #{field.name}=(v); @#{field.name} = #{field.type}.resolve(v) || v; end"
          }.join("\n") + "\n"
      end

      def required_writers
        # We generate attr_accessors for required fields, so no need for writers
        ""
      end

      def optional_writers
        return "" unless optional_fields.length > 0

        "  # BEGIN writers for optional fields\n" +
        optional_fields.map { |field|
          <<-eorb
  def #{field.name}=(v)
    #{set_bitmask(field)}
    @#{field.name} = v
  end
          eorb
        }.join("\n") +
        "  # END writers for optional fields\n\n"
      end

      def oneof_writers
        return "" unless oneof_fields.length > 0

        "  # BEGIN writers for oneof fields\n" +
        oneof_fields.map { |oneof|
          oneof.fields.map { |field|
            <<-eorb
  def #{field.name}=(v)
    @#{oneof.name} = :#{field.name}
    @#{field.name} = v
  end
            eorb
          }.join("\n")
        }.join("\n") +
        "  # END writers for oneof fields\n\n"
      end

      def initialize_code
        "  def initialize(" + initialize_signature + ")\n" +
          init_bitmask(message) +
          fields.map { |field|
            if field.field?
              initialize_field(field)
            elsif field.oneof?
              initialize_oneof(field)
            else
              p field
              raise
            end
          }.join("\n") + "\n  end\n\n"
      end

      def initialize_oneof(oneof)
        "    @#{oneof.name} = nil # oneof field\n" +
          oneof.fields.map { |field|
            <<-eoruby
    if #{field.name} == NONE
      @#{field.name} = #{default_for(field)}
    else
      @#{oneof.name} = :#{field.name}
      @#{field.name} = #{field.name}
    end
            eoruby
          }.join("\n")
      end

      def initialize_field(field)
        if field.optional?
          initialize_optional_field(field)
        elsif field.field? && enum?(field.type)
          initialize_enum_field(field)
        else
          initialize_required_field(field)
        end
      end

      def initialize_optional_field(field)
        <<-eoruby
    if #{field.name} == NONE
      @#{field.name} = #{default_for(field)}
    else
      #{set_bitmask(field)}
      @#{field.name} = #{field.name}
    end
        eoruby
      end

      def initialize_required_field(field)
        "    @#{field.name} = #{field.name}"
      end

      def initialize_enum_field(field)
        "    @#{field.name} = #{field.type}.resolve(#{field.name}) || #{field.name}"
      end

      def extra_api
        optional_predicates
      end

      def optional_predicates
        return "" unless optional_fields.length > 0

        optional_fields.map { |field|
          <<-eoruby
  def has_#{field.name}?
    #{test_bitmask(field)}
  end
          eoruby
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

      PULL_VARINT = ERB.new(<<-ruby, trim_mode: '-')
      if (byte0 = buff.getbyte(index)) < 0x80
        index += 1
        byte0
      else
        if (byte1 = buff.getbyte(index + 1)) < 0x80
          index += 2
          (byte1 << 7) | (byte0 & 0x7F)
        else
          if (byte2 = buff.getbyte(index + 2)) < 0x80
            index += 3
            (byte2 << 14) |
                    ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
          else
            if (byte3 = buff.getbyte(index + 3)) < 0x80
              index += 4
              (byte3 << 21) |
                      ((byte2 & 0x7F) << 14) |
                      ((byte1 & 0x7F) << 7) |
                      (byte0 & 0x7F)
            else
              if (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) |
                        ((byte3 & 0x7F) << 21) |
                        ((byte2 & 0x7F) << 14) |
                        ((byte1 & 0x7F) << 7) |
                        (byte0 & 0x7F)
              else
                if (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) |
                          ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) |
                          ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) |
                          (byte0 & 0x7F)
                else
                  if (byte6 = buff.getbyte(index + 6)) < 0x80
                    index += 7
                    (byte6 << 42) |
                            ((byte5 & 0x7F) << 35) |
                            ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) |
                            ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) |
                            (byte0 & 0x7F)
                  else
                    if (byte7 = buff.getbyte(index + 7)) < 0x80
                      index += 8
                      (byte7 << 49) |
                              ((byte6 & 0x7F) << 42) |
                              ((byte5 & 0x7F) << 35) |
                              ((byte4 & 0x7F) << 28) |
                              ((byte3 & 0x7F) << 21) |
                              ((byte2 & 0x7F) << 14) |
                              ((byte1 & 0x7F) << 7) |
                              (byte0 & 0x7F)
                    else
                      if (byte8 = buff.getbyte(index + 8)) < 0x80
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
                      else
                        if (byte9 = buff.getbyte(index + 9)) < 0x80
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
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      ruby

      PULL_STRING = ERB.new(<<-ruby, trim_mode: '-')
      value = <%= pull_varint %>

      <%= dest %> <%= operator %> buff.byteslice(index, value)
      index += value
      ruby

      PULL_BYTES = ERB.new(<<-ruby, trim_mode: '-')
      value = <%= pull_varint %>

      <%= dest %> <%= operator %> buff.byteslice(index, value).force_encoding(Encoding::ASCII_8BIT)
      index += value
      ruby

      PULL_SINT32 = ERB.new(<<-ruby, trim_mode: '-')
      ## PULL SINT32
      value = <%= pull_varint %>

      # If value is even, then it's positive
      <%= dest %> <%= operator %> (if value.even?
        value >> 1
      else
        -((value + 1) >> 1)
      end)
      ## END PULL SINT32
      ruby

      DECODE_METHOD = ERB.new(<<-ruby, trim_mode: '-')
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
      ruby

      PACKED_REPEATED = ERB.new(<<ruby)
        <%= pull_uint64("value", "=") %>
        goal = index + value
        list = @<%= field.name %>
        while true
          break if index >= goal
          <%= decode_subtype(field.type, "list", "<<") %>
        end
ruby

      def pull_tag
        str = <<-eoruby
        tag = buff.getbyte(index)
        index += 1
        eoruby

        if $DEBUG
          str += "puts \"reading field \#{tag >> 3} type: \#{tag & 0x7} \#{tag}\"\n"
        end

        str
      end

      def default_for(field)
        if field.field?
          if field.repeated?
            "[]"
          else
            if enum?(field.type)
              0
            else
              case field.type
              when "string", "bytes"
                '""'
              when "uint64", "int32", "sint32", "uint32", "int64", "sint64", "fixed64", "fixed32"
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
        if enum?(field.type)
          ProtoBoeuf::Field::VARINT
        else
          field.wire_type
        end
      end

      def decode_subtype(type, dest, operator)
        if enum?(type)
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
        "        ## PULL_MAP\n" +
        "        map = @#{field.name}\n" +
        "        while tag == #{tag_for_field(field, field.number)}\n" +
        pull_uint64("value", "=") + "\n" +
        "          index += 1\n" + # skip the tag, assume it's the key
        decode_subtype(field.type.key_type, "key", "=") + "\n" +
        "          index += 1\n" + # skip the tag, assume it's the value
        decode_subtype(field.type.value_type, "map[key]", "=") + "\n" +
        "          return self if index >= len\n" +
        pull_tag + "\n" +
        "        end\n"
      end

      def decode_repeated(field)
        <<-eoruby
        ## DECODE REPEATED
        list = @#{field.name}
        while true
          #{decode_subtype(field.type, "list", "<<")}
          #{pull_tag}
          break unless tag == #{tag_for_field(field, field.number)}
        end
        ## END DECODE REPEATED
        eoruby
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

        "        ## PULL_MESSAGE\n" +
          pull_uint64("msg_len", "=") + "\n" +
          "        #{dest} #{operator} #{type}.allocate.decode_from(buff, index, index += msg_len)\n" +
          "        ## END PULL_MESSAGE\n"
      end

      def pull_int64(dest, operator)
        "        ## PULL_INT64\n" +
          "        #{dest} #{operator} #{pull_varint(sign: :i64)}\n" +
          "        ## END PULL_INT64\n"
      end

      def pull_int32(dest, operator)
        "        ## PULL_INT32\n" +
          "        #{dest} #{operator} #{pull_varint(sign: :i32)}\n" +
          "        ## END PULL_INT32\n"
      end

      def pull_sint32(dest, operator)
        PULL_SINT32.result(binding)
      end

      def pull_varint(sign: false)
        PULL_VARINT.result(binding)
      end

      alias :pull_sint64 :pull_sint32

      def pull_string(dest, operator)
        "        ## PULL_STRING\n" +
          PULL_STRING.result(binding) +
          "        ## END PULL_STRING\n"
      end

      def pull_bytes(dest, operator)
        "        ## PULL_BYTES\n" +
          PULL_BYTES.result(binding) +
          "        ## END PULL_BYTES\n"
      end

      def pull_uint64(dest, operator)
        "        ## PULL_UINT64\n" +
          "        #{dest} #{operator} #{pull_varint}\n" +
          "        ## END PULL_UINT64\n"
      end

      alias :pull_uint32 :pull_uint64

      def pull_boolean(dest, operator)
        "        ## PULL BOOLEAN\n" +
          "        #{dest} #{operator} (buff.getbyte(index) == 1)\n" +
          "        index += 1\n" +
          "        ## END PULL BOOLEAN\n"
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
            decode_subtype(field.type, "@#{field.name}", "=")
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
      # This is a poorman's indent prettier.
      # TODO: We really should build a ruby AST and then apply a ruby serializer that pretties appropriately

      indent_level = 0
      indent = -> { "  " * ((indent_level += 1) - 1) }
      unindent = -> { "  " * (indent_level -= 1) }
      indent_lines = ->(body) { body.split("\n").map { |line| ("  " * indent_level) + line }.join("\n") }

      packages = (@ast.package || "").split(".").reject(&:empty?)
      head = "# frozen_string_literal: true\n\n"
      head += packages.map { |m| indent.call + "module " + m.split("_").map(&:capitalize).join + "\n" }.join

      toplevel_enums = @ast.enums.group_by(&:name)
      body = indent_lines.call(@ast.enums.map { |enum| EnumCompiler.result(enum) }.join) + "\n"
      body += indent_lines.call(@ast.messages.map { |message| MessageCompiler.result(message, toplevel_enums) }.join)

      tail = "\n" + packages.map { unindent.call + "end" }.join("\n")

      (head + body + tail).gsub(/[ ]*(?=$)/, '')
    end
  end
end
