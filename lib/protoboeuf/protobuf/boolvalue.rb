# encoding: ascii-8bit
# frozen_string_literal: true

module ProtoBoeuf
  module Protobuf
    class BoolValue
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode(+"").force_encoding(Encoding::ASCII_8BIT)
      end
      # required field readers

      attr_reader :value

      def value=(v)
        @value = v
      end

      def initialize(value: false)
        @value = value
      end

      def decode_from(buff, index, len)
        @value = false

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0x8
            ## PULL BOOLEAN
            @value = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @value
        if val == true
          buff << 0x08

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
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
