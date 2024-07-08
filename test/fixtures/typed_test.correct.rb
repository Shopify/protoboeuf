# encoding: ascii-8bit
# typed: strict
# frozen_string_literal: false

class BufferWithKnownLength < String
  extend T::Sig
  sig { params(offset: Integer).returns(Integer) }
  def getbyte(offset)
    T.must(super(offset))
  end

  sig { params(start: Integer, length: Integer).returns(String) }
  def byteslice(start, length)
    T.must(super(start, length))
  end
end

module TestEnum
  extend T::Sig

  FOO = 0
  BAR = 1
  BAZ = 2

  sig { params(val: Integer).returns(T.nilable(Symbol)) }
  def self.lookup(val)
    if val == 0
      :FOO
    elsif val == 1
      :BAR
    elsif val == 2
      :BAZ
    end
  end

  sig { params(val: Symbol).returns(T.nilable(Integer)) }
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
  extend T::Sig

  BAZBAZ = 0
  BARBAR = 1
  FOOFOO = 2

  sig { params(val: Integer).returns(T.nilable(Symbol)) }
  def self.lookup(val)
    if val == 0
      :BAZBAZ
    elsif val == 1
      :BARBAR
    elsif val == 2
      :FOOFOO
    end
  end

  sig { params(val: Symbol).returns(T.nilable(Integer)) }
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
  sig { returns(T::Array[Integer]) }
  attr_reader :repeated_ints

  sig { returns(T::Hash[String, Integer]) }
  attr_reader :map_field

  sig { returns(String) }
  attr_reader :bytes_field

  # optional field readers
  sig { returns(T.nilable(Integer)) }
  attr_reader :int_field

  sig { returns(T.nilable(String)) }
  attr_reader :string_field

  # oneof field readers
  sig { returns(T.nilable(Symbol)) }
  attr_reader :oneof_field
  sig { returns(String) }
  attr_reader :string_1
  sig { returns(String) }
  attr_reader :string_2

  sig { params(v: T::Array[Integer]).void }
  def repeated_ints=(v)
    v.each do |v|
      unless -2_147_483_648 <= v && v <= 2_147_483_647
        raise RangeError,
              "Value (#{v}}) for field repeated_ints is out of bounds (-2147483648..2147483647)"
      end
    end

    @repeated_ints = v
  end

  sig { params(v: T::Hash[String, Integer]).void }
  def map_field=(v)
    @map_field = v
  end

  sig { params(v: String).void }
  def bytes_field=(v)
    @bytes_field = v
  end

  # BEGIN writers for optional fields
  sig { params(v: T.nilable(Integer)).void }
  def int_field=(v)
    if v && (v < -2_147_483_648 || v > 2_147_483_647)
      raise RangeError,
            "Value (#{v}) for field int_field is out of bounds (-2147483648..2147483647)"
    end

    @_bitmask |= 0x0000000000000001
    @int_field = v || 0
  end

  sig { params(v: T.nilable(String)).void }
  def string_field=(v)
    @_bitmask |= 0x0000000000000002
    @string_field = v || "".freeze
  end
  # END writers for optional fields

  # BEGIN writers for oneof fields
  sig { params(v: String).void }
  def string_1=(v)
    @oneof_field = :string_1
    @string_1 = v
  end

  sig { params(v: String).void }
  def string_2=(v)
    @oneof_field = :string_2
    @string_2 = v
  end
  # END writers for oneof fields

  sig do
    params(
      int_field: T.nilable(Integer),
      string_field: T.nilable(String),
      string_1: T.nilable(String),
      string_2: T.nilable(String),
      repeated_ints: T::Array[Integer],
      map_field: T::Hash[String, Integer],
      bytes_field: String
    ).void
  end
  def initialize(
    int_field: nil,
    string_field: nil,
    string_1: nil,
    string_2: nil,
    repeated_ints: [],
    map_field: {},
    bytes_field: "".freeze
  )
    @_bitmask = T.let(0, Integer)

    @int_field = T.let(int_field || 0, T.nilable(Integer))
    if int_field && (int_field < -2_147_483_648 || int_field > 2_147_483_647)
      raise RangeError,
            "Value (#{int_field}) for field int_field is out of bounds (-2147483648..2147483647)"
    end
    @_bitmask |= 0x0000000000000001 if int_field

    @string_field = T.let(string_field || "".freeze, T.nilable(String))

    @_bitmask |= 0x0000000000000002 if string_field

    @oneof_field = T.let(nil, T.nilable(Symbol)) # oneof field
    @string_1 = T.let(string_1 || "".freeze, String)

    @oneof_field = :string_1 if string_1

    @string_2 = T.let(string_2 || "".freeze, String)

    @oneof_field = :string_2 if string_2

    repeated_ints.each do |v|
      unless -2_147_483_648 <= v && v <= 2_147_483_647
        raise RangeError,
              "Value (#{v}}) for field repeated_ints is out of bounds (-2147483648..2147483647)"
      end
    end
    @repeated_ints = T.let(repeated_ints, T::Array[Integer])

    @map_field = T.let(map_field, T::Hash[String, Integer])

    @bytes_field = T.let(bytes_field, String)
  end

  sig { returns(T::Boolean) }
  def has_int_field?
    (@_bitmask & 0x0000000000000001) == 0x0000000000000001
  end

  sig { returns(T::Boolean) }
  def has_string_field?
    (@_bitmask & 0x0000000000000002) == 0x0000000000000002
  end

  sig { params(buff: String, index: Integer, len: Integer).returns(Test1) }
  def decode_from(buff, index, len)
    buff = T.cast(buff, BufferWithKnownLength)
    @_bitmask = 0

    @int_field = 0
    @string_field = "".freeze
    @oneof_field = nil # oneof field
    @string_1 = "".freeze
    @string_2 = "".freeze
    @repeated_ints = []
    @map_field = {}
    @bytes_field = "".freeze

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

        @_bitmask |= 0x0000000000000001
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

        @_bitmask |= 0x0000000000000002
        return self if index >= len
        tag = buff.getbyte(index)
        index += 1
      end
      if tag == 0x1a
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

        @string_1 = buff.byteslice(index, value)
        index += value

        ## END PULL_STRING

        @oneof_field = :string_1
        return self if index >= len
        tag = buff.getbyte(index)
        index += 1
      end
      if tag == 0x22
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

        @string_2 = buff.byteslice(index, value)
        index += value

        ## END PULL_STRING

        @oneof_field = :string_2
        return self if index >= len
        tag = buff.getbyte(index)
        index += 1
      end
      if tag == 0x2a
        ## PULL_UINT64
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

        ## END PULL_UINT64

        goal = index + value
        list = @repeated_ints
        while true
          break if index >= goal
          ## PULL_INT32
          list << if (byte0 = buff.getbyte(index)) < 0x80
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
        end

        return self if index >= len
        tag = buff.getbyte(index)
        index += 1
      end
      if tag == 0x32
        ## PULL_MAP
        map = @map_field
        while tag == 0x32
          ## PULL_UINT64
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

          ## END PULL_UINT64

          index += 1 # skip the tag, assume it's the key
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

          key = buff.byteslice(index, value)
          index += value

          ## END PULL_STRING

          index += 1 # skip the tag, assume it's the value
          ## PULL_INT32
          map[key] = if (byte0 = buff.getbyte(index)) < 0x80
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

        return self if index >= len
      end
      if tag == 0x3a
        ## PULL_BYTES
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

        @bytes_field =
          buff.byteslice(index, value).force_encoding(Encoding::ASCII_8BIT)
        index += value

        ## END PULL_BYTES

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

    if @oneof_field == :"string_1"
      val = @string_1
      if ((len = val.bytesize) > 0)
        buff << 0x1a
        while len != 0
          byte = len & 0x7F
          len >>= 7
          byte |= 0x80 if len > 0
          buff << byte
        end

        buff << val
      end
    end

    if @oneof_field == :"string_2"
      val = @string_2
      if ((len = val.bytesize) > 0)
        buff << 0x22
        while len != 0
          byte = len & 0x7F
          len >>= 7
          byte |= 0x80 if len > 0
          buff << byte
        end

        buff << val
      end
    end

    list = @repeated_ints
    if list.size > 0
      buff << 0x2a
      len = list.size
      while len != 0
        byte = len & 0x7F
        len >>= 7
        byte |= 0x80 if len > 0
        buff << byte
      end

      list.each do |item|
        if item != 0
          while item != 0
            byte = item & 0x7F

            item >>= 7
            # This drops the top bits,
            # Otherwise, with a signed right shift,
            # we get infinity one bits at the top
            item &= (1 << 57) - 1

            byte |= 0x80 if item != 0
            buff << byte
          end
        end
      end
    end

    map = @map_field
    if map.size > 0
      old_buff = buff
      map.each do |key, value|
        buff = new_buffer = ""

        if ((len = key.bytesize) > 0)
          buff << 0x0a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << key
        end

        if value != 0
          buff << 0x10

          while value != 0
            byte = value & 0x7F

            value >>= 7
            # This drops the top bits,
            # Otherwise, with a signed right shift,
            # we get infinity one bits at the top
            value &= (1 << 57) - 1

            byte |= 0x80 if value != 0
            buff << byte
          end
        end

        buff = old_buff
        buff << 0x32
        len = new_buffer.bytesize
        while len != 0
          byte = len & 0x7F
          len >>= 7
          byte |= 0x80 if len > 0
          buff << byte
        end

        old_buff.concat(new_buffer)
      end
    end

    val = @bytes_field
    if ((bs = val.bytesize) > 0)
      buff << 0x3a
      len = bs
      while len != 0
        byte = len & 0x7F
        len >>= 7
        byte |= 0x80 if len > 0
        buff << byte
      end

      buff.concat(val.b)
    end

    buff
  end

  sig { returns(T::Hash[Symbol, T.untyped]) }
  def to_h
    result = {}
    result["int_field".to_sym] = @int_field
    result["string_field".to_sym] = @string_field
    send("oneof_field").tap { |f| result[f.to_sym] = send(f) if f }
    result["repeated_ints".to_sym] = @repeated_ints
    result["map_field".to_sym] = @map_field
    result["bytes_field".to_sym] = @bytes_field
    result
  end
end
