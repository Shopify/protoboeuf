# frozen_string_literal: true

module ProtoBoeuf
  module Protobuf

    class BoolValue
      def self.decode(buff)
        buff = buff.dup
        buff.force_encoding("UTF-8")
        allocate.decode_from(buff, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode
      end
      # required field readers
      attr_accessor :value

      # enum readers

      # enum writers

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
          raise NotImplementedError
        end
      end
    def _encode
      buff = ''.b

      buff
    end
    end
  end
end