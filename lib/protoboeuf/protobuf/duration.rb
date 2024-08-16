# encoding: ascii-8bit
# frozen_string_literal: true

module ProtoBoeuf
  module Protobuf
    class Duration
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      attr_reader :seconds

      attr_reader :nanos

      def seconds=(v)
        unless -9_223_372_036_854_775_808 <= v && v <= 9_223_372_036_854_775_807
          raise RangeError,
                "Value (#{v}) for field seconds is out of bounds (-9223372036854775808..9223372036854775807)"
        end

        @seconds = v
      end

      def nanos=(v)
        unless -2_147_483_648 <= v && v <= 2_147_483_647
          raise RangeError,
                "Value (#{v}) for field nanos is out of bounds (-2147483648..2147483647)"
        end

        @nanos = v
      end

      def initialize(seconds: 0, nanos: 0)
        unless -9_223_372_036_854_775_808 <= seconds &&
                 seconds <= 9_223_372_036_854_775_807
          raise RangeError,
                "Value (#{seconds}) for field seconds is out of bounds (-9223372036854775808..9223372036854775807)"
        end
        @seconds = seconds

        unless -2_147_483_648 <= nanos && nanos <= 2_147_483_647
          raise RangeError,
                "Value (#{nanos}) for field nanos is out of bounds (-2147483648..2147483647)"
        end
        @nanos = nanos
      end

      def decode_from(buff, index, len)
        @seconds = 0
        @nanos = 0

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0x8
            ## PULL_INT64
            @seconds =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x10
            ## PULL_INT32
            @nanos =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT32

            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @seconds
        if val != 0
          buff << 0x08

          while val != 0
            byte = val & 0x7F

            val >>= 7
            # This drops the top bits,
            # Otherwise, with a signed right shift,
            # we get infinity one bits at the top
            val &= (1 << 57) - 1

            byte |= 0x80 if val != 0
            buff << byte
          end
        end

        val = @nanos
        if val != 0
          buff << 0x10

          while val != 0
            byte = val & 0x7F

            val >>= 7
            # This drops the top bits,
            # Otherwise, with a signed right shift,
            # we get infinity one bits at the top
            val &= (1 << 57) - 1

            byte |= 0x80 if val != 0
            buff << byte
          end
        end

        buff
      end

      def to_h
        result = {}
        result["seconds".to_sym] = @seconds
        result["nanos".to_sym] = @nanos
        result
      end
    end
  end
end
