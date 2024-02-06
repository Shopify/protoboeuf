require "minitest/autorun"
require "minitest/color"
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

          buff_idx += 1
          offset += 1

          # Break if this byte doesn't have a continuation bit
          break if byte < 0x80
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







  class TestSigned
    def self.decode(buff)
      obj = ::TestSigned.new

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

          buff_idx += 1
          offset += 1

          # Break if this byte doesn't have a continuation bit
          break if byte < 0x80
        end

        # If value is even, then it's positive
        if value % 2 == 0
          value = (value >> 1)
        else
          value = -((value + 1) >> 1)
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





  class TestString
    def self.decode(buff)
      obj = ::TestString.new

      buff_idx = 0

      tag = buff.getbyte buff_idx

      buff_idx += 1

      # You take the last three bits to get the wire type (0)
      wire_type = tag & 0x7

      # and then right-shift by three to get the field number (1).
      field_number = tag >> 3

      value = nil

      if wire_type == 2 # LEN
        len = 0
        offset = 0
        while true
          byte = buff.getbyte buff_idx
          part = byte & 0x7F # remove continuation bit

          # We need to convert to big endian, so we'll "prepend"
          len |= part << (7 * offset)

          buff_idx += 1
          offset += 1

          # Break if this byte doesn't have a continuation bit
          break if byte < 0x80
        end

        bytes = buff.byteslice(buff_idx, len)
        bytes.force_encoding('UTF-8')

        set_value_for_field_number(obj, field_number - 1, bytes)
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
  def test_decode_test1
    data = "\b\x96\x01".b
    obj = ProtoBuff::Test1.decode data
    assert_equal 150, obj.a
  end

  def test_decode_testsigned
    data = ::TestSigned.encode(TestSigned.new.tap { |x| x.a = -123 })
    obj = ProtoBuff::TestSigned.decode data
    assert_equal -123, obj.a

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
