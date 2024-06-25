# encoding: ascii-8bit
# typed: false
# frozen_string_literal: false

module TestEnum
  FOO = 0
  BAR = 1
  BAZ = 2

  sig { params(val: Integer).returns(Symbol) }
  def self.lookup(val)
    if val == 0
      :FOO
    elsif val == 1
      :BAR
    elsif val == 2
      :BAZ
    end
  end

  sig { params(val: Symbol).returns(Integer) }
  def self.resolve(val)
    if val == :FOO
      0
    elsif val == :BAR
      1
    elsif val == :BAZ
      2
    end
  end
end
module TestEnum2
  BAZBAZ = 0
  BARBAR = 1
  FOOFOO = 2

  sig { params(val: Integer).returns(Symbol) }
  def self.lookup(val)
    if val == 0
      :BAZBAZ
    elsif val == 1
      :BARBAR
    elsif val == 2
      :FOOFOO
    end
  end

  sig { params(val: Symbol).returns(Integer) }
  def self.resolve(val)
    if val == :BAZBAZ
      0
    elsif val == :BARBAR
      1
    elsif val == :FOOFOO
      2
    end
  end
end

class Test1
  extend T::Sig
  sig { params(buff: String).returns(Test1) }
  def self.decode(buff)
    allocate.decode_from(buff.b, 0, buff.bytesize)
  end

  sig { params(obj: Test1).returns(String) }
  def self.encode(obj)
    obj._encode("").force_encoding(Encoding::ASCII_8BIT)
  end
  # required field readers
  sig { returns(Integer) }
  attr_accessor :int_field

  # optional field readers
  sig { returns(T.nilable(String)) }
  attr_reader :string_field

  # oneof field readers
  sig { returns(Symbol) }
  attr_reader :oneof_field
  sig { returns(T.nilable(TestEnum)) }
  attr_reader :enum_1
  sig { returns(T.nilable(TestEnum2)) }
  attr_reader :enum_2

  # BEGIN writers for optional fields
  sig { params(v: String).void }
  def string_field=(v)
    @_bitmask |= 0x0000000000000001
    @string_field = v
  end
  # END writers for optional fields

  # BEGIN writers for oneof fields
  def enum_1=(v)
    @oneof_field = :enum_1
    @enum_1 = v
  end

  def enum_2=(v)
    @oneof_field = :enum_2
    @enum_2 = v
  end
  # END writers for oneof fields

  sig do
    params(
      int_field: Integer,
      string_field: T.nilable(String),
      enum_1: TestEnum,
      enum_2: TestEnum2
    ).void
  end
  def initialize(int_field: 0, string_field: nil, enum_1: nil, enum_2: nil)
    @_bitmask = 0
    @int_field = int_field
    if string_field == nil
      @string_field = "".freeze
    else
      @_bitmask |= 0x0000000000000001
      @string_field = string_field
    end

    @oneof_field = nil # oneof field
    if enum_1 == nil
      @enum_1 = nil
    else
      @oneof_field = :enum_1
      @enum_1 = enum_1
    end

    if enum_2 == nil
      @enum_2 = nil
    else
      @oneof_field = :enum_2
      @enum_2 = enum_2
    end
  end

  sig { returns(T::Boolean) }
  def has_string_field?
    (@_bitmask & 0x0000000000000001) == 0x0000000000000001
  end

  sig { params(buff: String, index: Integer, len: Integer).returns(Test1) }
  def decode_from(buff, index, len)
    @_bitmask = 0

    @int_field = 0
    @string_field = "".freeze
    @oneof_field = nil # oneof field
    @enum_1 = nil
    @enum_2 = nil

    tag = buff.getbyte(index)
    index += 1

    while true
      if tag == 0x8
        ## PULL_INT32
        @int_field =
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
            (byte4 << 28) | ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte5 = buff.getbyte(index + 5)) < 0x80
            index += 6
            (byte5 << 35) | ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
              ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte6 = buff.getbyte(index + 6)) < 0x80
            index += 7
            (byte6 << 42) | ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
              ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte7 = buff.getbyte(index + 7)) < 0x80
            index += 8
            (byte7 << 49) | ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
              ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
              ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte8 = buff.getbyte(index + 8)) < 0x80
            index += 9
            (byte8 << 56) | ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
              ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
              ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
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
      if tag == 0x12
        ## PULL_STRING
        value =
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
            (byte4 << 28) | ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte5 = buff.getbyte(index + 5)) < 0x80
            index += 6
            (byte5 << 35) | ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
              ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte6 = buff.getbyte(index + 6)) < 0x80
            index += 7
            (byte6 << 42) | ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
              ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte7 = buff.getbyte(index + 7)) < 0x80
            index += 8
            (byte7 << 49) | ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
              ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
              ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte8 = buff.getbyte(index + 8)) < 0x80
            index += 9
            (byte8 << 56) | ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
              ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
              ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte9 = buff.getbyte(index + 9)) < 0x80
            index += 10

            (byte9 << 63) | ((byte8 & 0x7F) << 56) | ((byte7 & 0x7F) << 49) |
              ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
              ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
              ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          else
            raise "integer decoding error"
          end

        @string_field = buff.byteslice(index, value)
        index += value

        ## END PULL_STRING

        @_bitmask |= 0x0000000000000001
        return self if index >= len
        tag = buff.getbyte(index)
        index += 1
      end
      if tag == 0x1a
        ## PULL_MESSAGE
        ## PULL_UINT64
        msg_len =
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
            (byte4 << 28) | ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte5 = buff.getbyte(index + 5)) < 0x80
            index += 6
            (byte5 << 35) | ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
              ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte6 = buff.getbyte(index + 6)) < 0x80
            index += 7
            (byte6 << 42) | ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
              ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte7 = buff.getbyte(index + 7)) < 0x80
            index += 8
            (byte7 << 49) | ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
              ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
              ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte8 = buff.getbyte(index + 8)) < 0x80
            index += 9
            (byte8 << 56) | ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
              ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
              ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte9 = buff.getbyte(index + 9)) < 0x80
            index += 10

            (byte9 << 63) | ((byte8 & 0x7F) << 56) | ((byte7 & 0x7F) << 49) |
              ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
              ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
              ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          else
            raise "integer decoding error"
          end

        ## END PULL_UINT64

        @enum_1 = TestEnum.allocate.decode_from(buff, index, index += msg_len)
        ## END PULL_MESSAGE

        @oneof_field = :enum_1
        return self if index >= len
        tag = buff.getbyte(index)
        index += 1
      end
      if tag == 0x22
        ## PULL_MESSAGE
        ## PULL_UINT64
        msg_len =
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
            (byte4 << 28) | ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte5 = buff.getbyte(index + 5)) < 0x80
            index += 6
            (byte5 << 35) | ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
              ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte6 = buff.getbyte(index + 6)) < 0x80
            index += 7
            (byte6 << 42) | ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
              ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte7 = buff.getbyte(index + 7)) < 0x80
            index += 8
            (byte7 << 49) | ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
              ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
              ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte8 = buff.getbyte(index + 8)) < 0x80
            index += 9
            (byte8 << 56) | ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
              ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
              ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
              ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          elsif (byte9 = buff.getbyte(index + 9)) < 0x80
            index += 10

            (byte9 << 63) | ((byte8 & 0x7F) << 56) | ((byte7 & 0x7F) << 49) |
              ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
              ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
              ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
          else
            raise "integer decoding error"
          end

        ## END PULL_UINT64

        @enum_2 = TestEnum2.allocate.decode_from(buff, index, index += msg_len)
        ## END PULL_MESSAGE

        @oneof_field = :enum_2
        return self if index >= len
        tag = buff.getbyte(index)
        index += 1
      end

      return self if index >= len
    end
  end
  sig { params(buff: String).returns(String) }
  def _encode(buff)
    val = @int_field
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

    val = @string_field
    if ((len = val.bytesize) > 0)
      buff << 0x12
      while len != 0
        byte = len & 0x7F
        len >>= 7
        byte |= 0x80 if len > 0
        buff << byte
      end

      buff << val
    end

    if @oneof_field == :"enum_1"
      val = @enum_1
      if val
        encoded = val._encode("")
        buff << 0x1a
        len = encoded.bytesize
        while len != 0
          byte = len & 0x7F
          len >>= 7
          byte |= 0x80 if len > 0
          buff << byte
        end

        buff << encoded
      end
    end

    if @oneof_field == :"enum_2"
      val = @enum_2
      if val
        encoded = val._encode("")
        buff << 0x22
        len = encoded.bytesize
        while len != 0
          byte = len & 0x7F
          len >>= 7
          byte |= 0x80 if len > 0
          buff << byte
        end

        buff << encoded
      end
    end

    buff
  end

  sig { returns(T::Hash[Symbol, T.untyped]) }
  def to_h
    result = {}
    result["int_field".to_sym] = @int_field
    result["string_field".to_sym] = @string_field
    send("oneof_field").tap { |f| result[f.to_sym] = send(f) if f }
    result
  end
end
