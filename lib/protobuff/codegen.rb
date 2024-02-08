require "erb"

module ProtoBuff
  class CodeGen
    CLASS_TEMPLATE = ERB.new(<<-ruby, trim_mode: '-')
class <%= message.name %>
  <%- if message.fields.length > 0 -%>
  def self.decode(buff)
    decode_from(ProtoBuff::Decoder.new(buff), buff.bytesize)
  end

  def self.decode_from(decoder, len)
    obj = <%= message.name %>.new

    while true
      break if decoder.index >= len

      tag = decoder.pull_tag
      <%- message.fields.each_with_index do |field, idx| -%>
      <%= idx == 0 ? "if" : "elsif" %> tag == <%= tag_for_field(field, field.number) %>
        <%= decode_code(field) %>
      <%- end -%>
      else
        raise
      end
    end

    obj
  end

  attr_accessor <%= message.fields.map { |f| ":" + f.name }.join(", ") %>

  def initialize(<%= initialize_signature(message) %>)
  <%- for field in message.fields -%>
    @<%= field.name %> = <%= field.name %>
  <%- end -%>
  <%- end -%>
  end
end
    ruby

    PACKED_REPEATED = ERB.new(<<ruby)
        idx = 0
        goal = decoder.index + decoder.pull_uint64
        list = obj.<%= field.name %>
        while true
          break if decoder.index >= goal
          list[idx] = <%= decode_subtype(field) %>
          idx += 1
        end
ruby

    def initialize(ast)
      @ast = ast
    end

    def to_ruby
      @ast.messages.map { |message|
        CLASS_TEMPLATE.result(binding)
      }.join
    end

    private

    def default_for(field)
      case field.qualifier
      when :optional
        case field.type
        when "string"
          '""'
        when "uint64", "int32", "sint32", "uint32", "int64"
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
        when "int64", "int32", "uint64", "bool", "sint32", "uint32"
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

    def decode_subtype(field)
      case field.type
      when "string"
        "decoder.pull_string"
      when "uint64"
        "decoder.pull_uint64"
      when "int32"
        "decoder.pull_int32"
      when "int64"
        "decoder.pull_int64"
      when "uint32"
        "decoder.pull_uint32"
      when "sint32"
        "decoder.pull_sint32"
      when "bool"
        "decoder.pull_boolean"
      when /[A-Z]+\w+/ # FIXME: this doesn't seem right...
        "#{field.type}.decode_from(decoder, decoder.index + decoder.pull_uint64)"
      else
        raise "Unknown field type #{field.type}"
      end
    end

    def decode_code(field)
      case field.qualifier
      when :optional
        "obj.#{field.name} = #{decode_subtype(field)}"
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
