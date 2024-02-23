# frozen_string_literal: true

require "erb"

module ProtoBuff
  class CodeGen
    class MessageCompiler
      def self.result(message)
        new(message).result
      end

      attr_reader :message, :fields, :oneof_fields
      attr_reader :optional_fields

      def initialize(message)
        @message = message
        @optional_field_bit_lut = []
        @fields = @message.fields

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
        "class #{message.name}\n" +
          class_body +
          "end\n"
      end

      private

      def class_body
        prelude +
          constants +
          readers +
          writers +
          initialize_code +
          extra_api +
          decode
      end

      def prelude
        <<-eoruby
  def self.decode(buff)
    buff = buff.dup
    buff.force_encoding("UTF-8")
    allocate.decode_from(buff, 0, buff.bytesize)
  end

        eoruby
      end

      def constants
        if message.fields.any? { |msg| msg.oneof? || msg.optional? }
          <<-eoruby
  NONE = Object.new
  private_constant :NONE

          eoruby
        else
          ""
        end
      end

      def readers
        required_readers + optional_readers + oneof_readers
      end

      def required_readers
        fields = message.fields.select(&:field?).reject(&:optional?)
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
        required_writers + optional_writers + oneof_writers
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
        "attr_reader " + fields.map { |f| ":" + f.name }.join(", ")
      end

      PULL_MESSAGE = ERB.new(<<-ruby, trim_mode: '-')
      ## PULL_MESSAGE
      <%= pull_uint64("msg_len") %>
      <%= dest %> = <%= field.type %>.allocate.decode_from(buff, index, index += msg_len)
      ## END PULL_MESSAGE
      ruby

      PULL_BOOLEAN = ERB.new(<<-ruby, trim_mode: '-')
      byte = buff.getbyte index
      index += 1
      <%= dest %> = byte == 1
      ruby

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

      <%= dest %> = buff.byteslice(index, value)
      index += value
      ruby

      PULL_SINT32 = ERB.new(<<-ruby, trim_mode: '-')
      ## PULL SINT32
      <%= dest %> = <%= pull_varint %>

      # If value is even, then it's positive
      <%= dest %> = if <%= dest %>.even?
        <%= dest %> >> 1
      else
        -((<%= dest %> + 1) >> 1)
      end
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

    <%= pull_tag %>

    while true
      <%- fields.each do |field| -%>
        <%- if field.field? -%>
      if tag == <%= tag_for_field(field, field.number) %>
        <%= decode_code(field) %>
        <%= set_bitmask(field) if field.optional? %>
        return self if index >= len
        <%= pull_tag %>
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

      raise NotImplementedError
    end
  end
      ruby

      PACKED_REPEATED = ERB.new(<<ruby)
        idx = 0
        <%= pull_uint64("value") %>
        goal = index + value
        list = @<%= field.name %>
        while true
          break if index >= goal
          <%= decode_subtype(field, "list[idx]") %>
          idx += 1
        end
ruby

      def pull_tag
        <<-eoruby
        tag = buff.getbyte(index)
        index += 1
        eoruby
      end

      def default_for(field)
        if field.field?
          if field.repeated?
            "[]"
          else
            case field.type
            when "string"
              '""'
            when "uint64", "int32", "sint32", "uint32", "int64", "sint64"
              0
            when "bool"
              false
            when /[A-Z]+\w+/ # FIXME: this doesn't seem right...
              'nil'
            else
              raise "Unknown field type #{field.type}"
            end
          end
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
        field.wire_type
      end

      def decode_subtype(field, dest)
        case field.type
        when "string" then pull_string(dest)
        when "uint64" then pull_uint64(dest)
        when "int64" then pull_int64(dest)
        when "int32" then pull_int32(dest)
        when "uint32" then pull_uint32(dest)
        when "sint32" then pull_sint32(dest)
        when "sint64" then pull_sint64(dest)
        when "bool" then pull_boolean(dest)
        when /[A-Z]+\w+/ # FIXME: this doesn't seem right...
          pull_message(field, dest)
        else
          raise "Unknown field type #{field.type}"
        end
      end

      def pull_message(field, dest)
        PULL_MESSAGE.result(binding)
      end

      def pull_int64(dest)
        "        ## PULL_INT64\n" +
          "        #{dest} = #{pull_varint(sign: :i64)}\n" +
          "        ## END PULL_INT64\n"
      end

      def pull_int32(dest)
        "        ## PULL_INT32\n" +
          "        #{dest} = #{pull_varint(sign: :i32)}\n" +
          "        ## END PULL_INT32\n"
      end

      def pull_sint32(dest)
        PULL_SINT32.result(binding)
      end

      def pull_varint(sign: false)
        PULL_VARINT.result(binding)
      end

      alias :pull_sint64 :pull_sint32

      def pull_string(dest)
        PULL_STRING.result(binding)
      end

      def pull_uint64(dest)
        "        ## PULL_UINT64\n" +
          "        #{dest} = #{pull_varint}\n" +
          "        ## END PULL_UINT64\n"
      end

      alias :pull_uint32 :pull_uint64

      def pull_boolean(dest)
        PULL_BOOLEAN.result(binding)
      end

      def decode_code(field)
        if field.repeated?
          case field.type
          when "uint32"
            PACKED_REPEATED.result(binding)
          else
            raise "Unknown field type #{field.type}"
          end
        else
          decode_subtype(field, "@#{field.name}")
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
      @ast = ast
    end

    def to_ruby
      head = "# frozen_string_literal: true\n"
      head += if @ast.package
        "module " + @ast.package.split('_').map(&:capitalize).join + "\n"
      else
        ""
      end

      tail = if @ast.package
        "end"
      else
        ""
      end

      head + @ast.messages.map { |message|
        MessageCompiler.result(message)
      }.join + tail
    end
  end
end
