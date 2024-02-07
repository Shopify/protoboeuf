# frozen_string_literal: true

module ProtoBuff
  class Decoder
    attr_reader :index

    def initialize(buff)
      @buff = buff
      @index = 0
    end

    def pull_tag
      tag = @buff.getbyte @index
      @index += 1
      tag
    end

    def pull_int32
      value = 0
      offset = 0

      while true
        byte = @buff.getbyte @index
        @index += 1

        part = byte & 0x7F # remove continuation bit

        # We need to convert to big endian, so we'll "prepend"
        value |= part << (7 * offset)

        offset += 1

        # Negative 32 bit integers are still encoded with 10 bytes
        # handle 2's complement negative numbers
        # If the top bit is 1, then it must be negative.
        if offset == 10 && part == 1
          value = -(((~value) & 0xFFFF_FFFF) + 1)
        end

        # Break if this byte doesn't have a continuation bit
        break if byte < 0x80
      end

      value
    end

    def pull_uint64
      value = 0
      offset = 0

      while true
        byte = @buff.getbyte @index
        @index += 1

        part = byte & 0x7F # remove continuation bit

        # We need to convert to big endian, so we'll "prepend"
        value |= part << (7 * offset)

        offset += 1

        # Break if this byte doesn't have a continuation bit
        break if byte < 0x80
      end

      value
    end

    alias :pull_uint32 :pull_uint64

    def pull_boolean
      byte = @buff.getbyte @index
      @index += 1
      byte == 1
    end

    def pull_sint32
      value = 0
      offset = 0
      while true
        byte = @buff.getbyte @index
        @index += 1

        part = byte & 0x7F # remove continuation bit

        # We need to convert to big endian, so we'll "prepend"
        value |= part << (7 * offset)

        offset += 1

        # Break if this byte doesn't have a continuation bit
        break if byte < 0x80
      end

      # If value is even, then it's positive
      if value % 2 == 0
        value >> 1
      else
        -((value + 1) >> 1)
      end
    end

    def pull_string
      len = 0
      offset = 0
      while true
        byte = @buff.getbyte @index
        @index += 1

        part = byte & 0x7F # remove continuation bit

        # We need to convert to big endian, so we'll "prepend"
        len |= part << (7 * offset)

        offset += 1

        # Break if this byte doesn't have a continuation bit
        break if byte < 0x80
      end

      bytes = @buff.byteslice(@index, len)
      @index += len
      bytes.force_encoding('UTF-8')
    end
  end
end
