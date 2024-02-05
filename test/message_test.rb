require "minitest/autorun"
require "proto/test/fixtures/test_pb"

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

      # https://protobuf.dev/programming-guides/encoding/#structure
      #
      # The “tag” of a record is encoded as a varint formed from the field
      # number and the wire type via the formula (field_number << 3) |
      # wire_type. In other words, after decoding the varint representing a
      # field, the low 3 bits tell us the wire type, and the rest of the
      # integer tells us the field number.

      buff_idx = 0

      tag = buff.getbyte buff_idx

      buff_idx += 1

      # You take the last three bits to get the wire type (0)
      wire_type = tag & 0x7

      # and then right-shift by three to get the field number (1).
      field_number = tag >> 3

      value = nil

      if wire_type == 0 # VARINT
        value = 0
        offset = 0
        while true
          byte = buff.getbyte buff_idx
          part = byte & 0x7F # remove continuation bit

          # We need to convert to big endian, so we'll "prepend"
          value |= part << (7 * offset)

          # Break if this byte doesn't have a continuation bit
          break if byte < 0x80

          buff_idx += 1
          offset += 1
        end

        set_value_for_field_number(obj, field_number - 1, value)
      else
        raise "unknown wire type #{wire_type}"
      end
      # decode buff
      obj
    end

    def self.set_value_for_field_number(recv, idx, value)
      # FIXME: we should generate an optimized version of this method
      # Map the field number to a method we need to call
      field_name = recv.class.descriptor.to_a[idx].name

      # send the method
      recv.send("#{field_name}=", value)
    end
  end
end

 class MessageTest < Minitest::Test
  def test_decode_test_message
    data = "\n\vhello world\x10\xD2\t".b
    obj = ProtoBuff::TestMessage.decode data

    assert_equal "hello world", obj.id
    assert_equal 1234, obj.shop_id
    assert_equal false, obj.boolean
  end

  def test_decode_test1
    data = "\b\x96\x01".b
    obj = ProtoBuff::Test1.decode data
    assert_equal 150, obj.a
  end

  def test_encode_test1
    data = "\b\x96\x01".b
    obj = Test1.new
    obj.a = 150
    assert_equal data, ProtoBuff::Test1.encode(obj)
  end
end
