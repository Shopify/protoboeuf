# frozen_string_literal: true

module ProtoBoeuf
  module Protobuf
    class FloatValue
      def self.decode(buff)
        buff = buff.b
        allocate.decode_from(buff, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode
      end
      # required field readers
      attr_accessor :value

      def initialize(value: 0.0)
        @value = value
      end

      def decode_from(buff, index, len)
        @value = 0.0

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xd
            @value = buff.byteslice(index, 4).unpack1("F")
            index += 4

            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
          raise NotImplementedError
        end
      end
      def _encode
        buff = "".b
        val = @value
        if val != 0
          ## encode the tag
          buff << 0x0d
          buff << [val].pack("F")
        end

        buff
      end
    end
  end
end
