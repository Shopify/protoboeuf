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
      byte0 = buff.getbyte index

      if byte0 < 0x80
        <%= dest %> = byte0
        offset = 1
      else
        byte1 = buff.getbyte(index + 1)

        if byte1 < 0x80
          <%= dest %> = (byte1 << 7) | (byte0 & 0x7F)
          offset = 2
        else
          byte2 = buff.getbyte(index + 2)

          if byte2 < 0x80
            <%= dest %> = (byte2 << 14) |
                    ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
            offset = 3
          else
            byte3 = buff.getbyte(index + 3)

            if byte3 < 0x80
              <%= dest %> = (byte3 << 21) |
                      ((byte2 & 0x7F) << 14) |
                      ((byte1 & 0x7F) << 7) |
                      (byte0 & 0x7F)
              offset = 4
            else
              byte4 = buff.getbyte(index + 4)

              if byte4 < 0x80
                <%= dest %> = (byte4 << 28) |
                        ((byte3 & 0x7F) << 21) |
                        ((byte2 & 0x7F) << 14) |
                        ((byte1 & 0x7F) << 7) |
                        (byte0 & 0x7F)
                offset = 5
              else
                byte5 = buff.getbyte(index + 5)

                if byte5 < 0x80
                  <%= dest %> = (byte5 << 35) |
                          ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) |
                          ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) |
                          (byte0 & 0x7F)
                  offset = 6
                else
                  byte6 = buff.getbyte(index + 6)

                  if byte6 < 0x80
                    <%= dest %> = (byte6 << 42) |
                            ((byte5 & 0x7F) << 35) |
                            ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) |
                            ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) |
                            (byte0 & 0x7F)
                    offset = 7
                  else
                    byte7 = buff.getbyte(index + 7)

                    if byte7 < 0x80
                      <%= dest %> = (byte7 << 49) |
                              ((byte6 & 0x7F) << 42) |
                              ((byte5 & 0x7F) << 35) |
                              ((byte4 & 0x7F) << 28) |
                              ((byte3 & 0x7F) << 21) |
                              ((byte2 & 0x7F) << 14) |
                              ((byte1 & 0x7F) << 7) |
                              (byte0 & 0x7F)
                      offset = 8
                    else
                      byte8 = buff.getbyte(index + 8)

                      if byte8 < 0x80
                        <%= dest %> = (byte8 << 56) |
                                ((byte7 & 0x7F) << 49) |
                                ((byte6 & 0x7F) << 42) |
                                ((byte5 & 0x7F) << 35) |
                                ((byte4 & 0x7F) << 28) |
                                ((byte3 & 0x7F) << 21) |
                                ((byte2 & 0x7F) << 14) |
                                ((byte1 & 0x7F) << 7) |
                                (byte0 & 0x7F)
                        offset = 9
                      else
                        byte9 = buff.getbyte(index + 9)

                        if byte9 < 0x80
                          <%= dest %> = (byte9 << 63) |
                                  ((byte8 & 0x7F) << 56) |
                                  ((byte7 & 0x7F) << 49) |
                                  ((byte6 & 0x7F) << 42) |
                                  ((byte5 & 0x7F) << 35) |
                                  ((byte4 & 0x7F) << 28) |
                                  ((byte3 & 0x7F) << 21) |
                                  ((byte2 & 0x7F) << 14) |
                                  ((byte1 & 0x7F) << 7) |
                                  (byte0 & 0x7F)
                          offset = 10
                        else
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
      index += offset
    ruby

    PULL_INT64 = ERB.new(<<-ruby, trim_mode: '-')
      ## PULL_INT64
      <%= pull_varint(dest) %>

      # Negative 32 bit integers are still encoded with 10 bytes
      # handle 2's complement negative numbers
      # If the top bit is 1, then it must be negative.
      if offset == 10
        <%= dest %> = -(((~<%= dest %>) & 0xFFFF_FFFF_FFFF_FFFF) + 1)
      end

      ## END PULL_INT64
    ruby

    PULL_UINT64 = ERB.new(<<-ruby, trim_mode: '-')
      ## PULL_UINT64
      <%= pull_varint(dest) %>

      ## END PULL_UINT64
    ruby

    PULL_STRING = ERB.new(<<-ruby, trim_mode: '-')
      <%= pull_varint("value") %>

      <%= dest %> = buff.byteslice(index, value)
      index += value
    ruby

    PULL_SINT32 = ERB.new(<<-ruby, trim_mode: '-')
      ## PULL SINT32
      <%= pull_varint(dest) %>

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
      <%= pull_varint(dest) %>

      # Negative 32 bit integers are still encoded with 10 bytes
      # handle 2's complement negative numbers
      # If the top bit is 1, then it must be negative.
      if offset == 10
        <%= dest %> = -(((~<%= dest %>) & 0xFFFF_FFFF) + 1)
      end

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

  attr_accessor <%= message.fields.map { |f| ":" + f.name }.join(", ") %>

  def initialize(<%= initialize_signature(message) %>)
  <%- for field in message.fields -%>
    @<%= field.name %> = <%= field.name %>
  <%- end -%>
  <%- end -%>
  end

  def decode_from(buff, index, len)
    <%- for field in message.fields -%>
      @<%= field.name %> = <%= default_for(field) %>
    <%- end -%>

    <%= pull_tag %>

    while true
      <%- message.fields.each do |field| -%>
      if tag == <%= tag_for_field(field, field.number) %>
        <%= decode_code(field) %>
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
      case field.qualifier
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
      case field.qualifier
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

    def pull_varint(dest)
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
      case field.qualifier
      when :optional
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
  end
end
