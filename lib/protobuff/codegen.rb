# frozen_string_literal: true

require "erb"

module ProtoBuff
  class CodeGen
    PULL_MESSAGE = ERB.new(<<-ruby, trim_mode: '-')
      ## PULL_MESSAGE
      <%= pull_uint64("msg_len") %>
      <%= dest %> = <%= field.type %>.allocate.decode_from(buff, index, index += msg_len)
      ## END PULL_MESSAGE
    ruby

    PULL_TAG = ERB.new(<<-ruby, trim_mode: '-')
      tag = buff.getbyte(index)
      index += 1
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

    PULL_INT64 = ERB.new(<<-ruby, trim_mode: '-')
      ## PULL_INT64
      <%= dest %> = <%= pull_varint(sign: :i64) %>
      ## END PULL_INT64
    ruby

    PULL_UINT64 = ERB.new(<<-ruby, trim_mode: '-')
      ## PULL_UINT64
      <%= dest %> = <%= pull_varint %>
      ## END PULL_UINT64
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

    PULL_INT32 = ERB.new(<<-ruby, trim_mode: '-')
      ## PULL INT32
      <%= dest %> = <%= pull_varint(sign: :i32) %>
      ## END PULL INT32
    ruby

    CLASS_TEMPLATE = ERB.new(<<-ruby, trim_mode: '-')
class <%= message.name %>
  <%- if message.fields.length > 0 -%>
  def self.decode(buff)
    buff = buff.dup
    buff.force_encoding("UTF-8")
    allocate.decode_from(buff, 0, buff.bytesize)
  end

  attr_accessor <%= required_fields(message).map { |f| ":" + f.name }.join(", ") %>
  attr_reader <%= optional_fields(message).map { |f| ":" + f.name }.join(", ") %>

  def initialize(<%= initialize_signature(message) %>)
  <%- for field in message.fields -%>
    @<%= field.name %> = <%= field.name %>
  <%- end -%>
  <%- end -%>
  <%= init_bitmask(message) %>
  end

  <%- optional_fields(message).each_with_index do |field, i| -%>
  def <%= field.name %>=(v)
    <%= set_bitmask(message, field) %>
    @<%= field.name %> = v
  end

  def has_<%= field.name %>?
    <%= test_bitmask(i) %>
  end
  <%- end -%>

  def decode_from(buff, index, len)
    <%- for field in message.fields -%>
      @<%= field.name %> = <%= default_for(field) %>
    <%- end -%>
    <%= init_bitmask(message) %>

    <%= pull_tag %>

    while true
      <%- message.fields.each do |field| -%>
      if tag == <%= tag_for_field(field, field.number) %>
        <%= decode_code(field) %>
        <%= set_bitmask(message, field) if field.qualifier == :optional %>
        return self if index >= len
        <%= pull_tag %>
      end
      <%- end -%>

      raise NotImplementedError
    end
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
        CLASS_TEMPLATE.result(binding)
      }.join + tail
    end

    private

    def pull_tag
      PULL_TAG.result(binding)
    end

    def default_for(field)
      case (field.qualifier || :optional)
      when :optional
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
      when :repeated
        "[]"
      else
        raise "Unknown qualifier #{field.type}"
      end
    end

    def initialize_signature(msg)
      msg.fields.map { |f| "#{f.name}: #{default_for(f)}" }.join(", ")
    end

    def tag_for_field(field, idx)
      sprintf("%#02x", (idx << 3 | wire_type(field)))
    end

    VARINT = 0
    I64 = 1
    LEN = 2
    I32 = 5

    def wire_type(field)
      case (field.qualifier || :optional)
      when :optional
        case field.type
        when "string"
          LEN
        when "int64", "int32", "uint64", "bool", "sint32", "sint64", "uint32"
          VARINT
        when /[A-Z]+\w+/ # FIXME: this doesn't seem right...
          LEN
        else
          raise "Unknown wire type for field #{field.type}"
        end
      when :repeated
        LEN
      else
        raise "Unknown qualifier #{field.qualifier}"
      end
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
      PULL_INT64.result(binding)
    end

    def pull_int32(dest)
      PULL_INT32.result(binding)
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
      PULL_UINT64.result(binding)
    end

    def pull_uint32(dest)
      PULL_UINT64.result(binding)
    end

    def pull_boolean(dest)
      PULL_BOOLEAN.result(binding)
    end

    def decode_code(field)
      case (field.qualifier || :required)
      when :optional, :required
        decode_subtype(field, "@#{field.name}")
      when :repeated
        case field.type
        when "uint32"
          PACKED_REPEATED.result(binding)
        else
          raise "Unknown field type #{field.type}"
        end
      else
        raise "Unknown qualifier #{field.qualifier}"
      end
    end

    def required_fields(msg)
      msg.fields.reject { |f| f.qualifier == :optional }
    end

    def optional_fields(msg)
      msg.fields.select { |f| f.qualifier == :optional }
    end

    def init_bitmask(msg)
      optionals = optional_fields(msg)
      raise NotImplementedError unless optionals.length < 63
      if optionals.length > 0
        "@_bitmask = 0"
      else
        ""
      end
    end

    def set_bitmask(msg, field)
      # FIXME: this is very inefficient. We're looping through all fields
      # too many times.
      i = optional_fields(msg).index(field)
      "@_bitmask |= #{sprintf("%#018x", 1 << i)}"
    end

    def test_bitmask(i)
      "(@_bitmask & #{sprintf("%#018x", 1 << i)}) == #{sprintf("%#018x", 1 << i)}"
    end
  end
end
