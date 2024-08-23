# encoding: ascii-8bit
# rubocop:disable all
# frozen_string_literal: true

module ProtoBoeuf
  module Protobuf
    class FloatValue
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      attr_reader :value

      def value=(v)
        @value = v
      end

      def initialize(value: 0.0)
        @value = value
      end

      def to_proto(_options = {})
        self.class.encode(self)
      end

      def decode_from(buff, index, len)
        @value = 0.0

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xd
            @value = buff.unpack1("e", offset: index)
            index += 4

            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @value
        if val != 0
          buff << 0x0d

          [val].pack("e", buffer: buff)
        end

        buff
      end

      def to_h
        result = {}
        result["value".to_sym] = @value
        result
      end
    end
  end
end
