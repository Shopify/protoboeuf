require "minitest/autorun"
require "minitest/color"
require "proto/test/fixtures/test_pb"
require "protobuff/decoder"

module ProtoBuff
  class TestMessage
    def self.decode(buff)
      obj = ::TestMessage.new
      # decode buff
      obj
    end
  end

  class Test1
    def self.decode(buff)
      obj = ::Test1.new

      decoder = ProtoBuff::Decoder.new buff

      # https://protobuf.dev/programming-guides/encoding/#structure

      tag = decoder.pull_tag

      # You take the last three bits to get the wire type (0)
      # wire_type = tag & 0x7

      # and then right-shift by three to get the field number (1).
      field_number = tag >> 3

      value = nil

      if field_number == 1
        # We know to pull an int32 because Test1 declared field 1 to be an int32
        # See `test/fixtures/test.proto`
        value = decoder.pull_int32

        # We know to set `a` because the .proto file declared field 1 to be "a"
        # See `test/fixtures/test.proto`
        obj.a = value
      else
        raise "unknown field type #{field_number}"
      end
      # decode buff
      obj
    end
  end

  class TestSigned
    def self.decode(buff)
      obj = ::TestSigned.new
      decoder = ProtoBuff::Decoder.new buff

      tag = decoder.pull_tag

      # You take the last three bits to get the wire type (0)
      # wire_type = tag & 0x7

      # and then right-shift by three to get the field number (1).
      field_number = tag >> 3

      value = nil

      if field_number == 1 # VARINT
        # We know to pull an sint32 because the proto file declared field 1 to be an sint32
        # See `test/fixtures/test.proto`
        value = decoder.pull_sint32

        # We know to set `a` because the .proto file declared field 1 to be "a"
        # See `test/fixtures/test.proto`
        obj.a = value
      else
        raise "unknown field type #{field_number}"
      end
      # decode buff
      obj
    end
  end

  class TestString
    def self.decode(buff)
      obj = ::TestString.new

      decoder = ProtoBuff::Decoder.new buff

      tag = decoder.pull_tag

      # You take the last three bits to get the wire type (0)
      wire_type = tag & 0x7

      # and then right-shift by three to get the field number (1).
      field_number = tag >> 3

      if field_number == 1 # LEN
        # We know to pull a string because the proto file declared field 1 to be a string
        # See `test/fixtures/test.proto`
        value = decoder.pull_string

        # We know to set `a` because the .proto file declared field 1 to be "a"
        # See `test/fixtures/test.proto`
        obj.a = value
      else
        raise "unknown field type #{field_number}"
      end
      # decode buff
      obj
    end
  end
end

class MessageTest < Minitest::Test
  def test_decode_test1
    data = "\b\x96\x01".b
    obj = ProtoBuff::Test1.decode data
    assert_equal 150, obj.a
  end

  def test_decode_testsigned
    data = ::TestSigned.encode(TestSigned.new.tap { |x| x.a = -123 })
    obj = ProtoBuff::TestSigned.decode data
    assert_equal(-123, obj.a)

    data = ::TestSigned.encode(TestSigned.new.tap { |x| x.a = 4004 })
    obj = ProtoBuff::TestSigned.decode data
    assert_equal 4004, obj.a
  end

  def test_decode_teststring
    data = ::TestString.encode(TestString.new.tap { |x| x.a = "foo" })
    obj = ProtoBuff::TestString.decode data
    assert_equal "foo", obj.a
  end
end
