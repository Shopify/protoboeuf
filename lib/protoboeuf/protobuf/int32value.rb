# frozen_string_literal: true

module ProtoBoeuf
  module Protobuf

    class Int32Value
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

      def initialize(value: 0)
        @value = value
      end

      def decode_from(buff, index, len)

          @value = 0

                tag = buff.getbyte(index)
            index += 1


        while true
          if tag == 0x8
                    ## PULL_INT32
            @value =       if (byte0 = buff.getbyte(index)) < 0x80
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

            ## END PULL_INT32


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