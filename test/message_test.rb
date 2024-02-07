require "minitest/autorun"
require "minitest/color"
require "proto/test/fixtures/test_pb"
require "protobuff/decoder"

module ProtoBuff
  class TestRepeatedField
    attr_accessor :e

    def initialize
      @e = []
    end

    def self.decode(buff)
      decode_from(ProtoBuff::Decoder.new(buff), buff.bytesize)
    end

    def self.decode_from(decoder, len)
      obj = TestRepeatedField.new

      while true
        break if decoder.index >= len

        tag = decoder.pull_tag

        if tag == (0x2 | (1 << 3))
          idx = 0
          goal = decoder.index + decoder.pull_uint64
          while true
            break if decoder.index >= goal
            obj.e[idx] = decoder.pull_uint32
            idx += 1
          end
        else
          raise NotImplementedError
        end
      end

      obj
    end
  end

  class TestEmbedder
    attr_accessor :id, :value, :message

    def initialize
      @id = 0
      @value = nil
      @message = ""
    end

    def self.decode(buff)
      decode_from(ProtoBuff::Decoder.new(buff), buff.bytesize)
    end

    def self.decode_from(decoder, len)
      obj = TestEmbedder.new

      while true
        break if decoder.index >= len

        tag = decoder.pull_tag

        field_number = tag >> 3

        if field_number == 1
          obj.id = decoder.pull_uint64
        elsif field_number == 2
          obj.value = TestEmbeddee.decode_from(decoder, decoder.index + decoder.pull_uint64)
        elsif field_number == 3
          obj.message = decoder.pull_string
        else
          raise "Unknown field number #{field_number}"
        end
      end

      obj
    end
  end

  class TestEmbeddee
    attr_accessor :value

    def initialize
      @value = 0
    end

    def self.decode(buff)
      decode_from(ProtoBuff::Decoder.new(buff), buff.bytesize)
    end

    def self.decode_from(decoder, len)
      obj = TestEmbeddee.new

      while true
        break if decoder.index >= len

        tag = decoder.pull_tag

        field_number = tag >> 3

        if field_number == 1
          obj.value = decoder.pull_uint64
        else
          raise "Unknown field number #{field_number}"
        end
      end

      obj
    end
  end

  class TestMessage
    attr_accessor :id, :shop_id, :boolean

    def initialize
      @id = ""
      @shop_id = 0
      @boolean = false
    end

    def self.decode(buff)
      decode_from(ProtoBuff::Decoder.new(buff), buff.bytesize)
    end

    def self.decode_from(decoder, len)
      obj = TestMessage.new

      while true
        break if decoder.index >= len

        tag = decoder.pull_tag

        field_number = tag >> 3

        if field_number == 1
          obj.id = decoder.pull_string
        elsif field_number == 2
          obj.shop_id = decoder.pull_uint64
        elsif field_number == 3
          obj.boolean = decoder.pull_boolean
        else
          raise "Unknown field number #{field_number}"
        end
      end

      obj
    end
  end

  class Test1
    attr_accessor :a

    def initialize
      @a = 0
    end

    def self.decode(buff)
      decode_from(ProtoBuff::Decoder.new(buff), buff.bytesize)
    end

    def self.decode_from(decoder, len)
      obj = Test1.new

      while true
        break if decoder.index >= len

        tag = decoder.pull_tag

        field_number = tag >> 3

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
      end

      obj
    end
  end

  class TestSigned
    attr_accessor :a

    def initialize
      @a = 0
    end

    def self.decode(buff)
      decode_from(ProtoBuff::Decoder.new(buff), buff.bytesize)
    end

    def self.decode_from(decoder, len)
      obj = TestSigned.new

      while true
        break if decoder.index >= len
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
      end
      obj
    end
  end

  class TestString
    attr_accessor :a

    def initialize
      @a = ""
    end

    def self.decode(buff)
      decode_from(ProtoBuff::Decoder.new(buff), buff.bytesize)
    end

    def self.decode_from(decoder, len)
      obj = TestString.new

      while true
        break if decoder.index >= len
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
      end
      obj
    end
  end
end

class MessageTest < Minitest::Test
  def test_decode_repeated
    data = ::TestRepeatedField.encode(::TestRepeatedField.new.tap { |x|
      x.e[0] = 1
      x.e[1] = 2
      x.e[2] = 3
      x.e[3] = 0xFF
    })

    obj = ProtoBuff::TestRepeatedField.decode data
    3.times do |i|
      assert_equal i + 1, obj.e[i]
    end

    assert_equal 0xFF, obj.e[3]
  end

  def test_decode_embedded
    data = ::TestEmbedder.encode(::TestEmbedder.new.tap { |x|
      x.id = 1234
      x.value = ::TestEmbeddee.new(value: 5678)
      x.message = "hello world"
    })

    obj = ProtoBuff::TestEmbedder.decode data
    assert_equal 1234, obj.id
    assert_equal 5678, obj.value.value
    assert_equal "hello world", obj.message
  end

  def test_decode_test_message
    data = ::TestMessage.encode(TestMessage.new.tap { |x|
      x.id = "hello world"
      x.shop_id = 1234
      x.boolean = false
    })

    obj = ProtoBuff::TestMessage.decode data
    assert_equal 1234, obj.shop_id
    assert_equal "hello world", obj.id
    assert_equal false, obj.boolean

    data = ::TestMessage.encode(TestMessage.new.tap { |x|
      x.id = "hello world2"
      x.shop_id = 555
      x.boolean = true
    })

    obj = ProtoBuff::TestMessage.decode data
    assert_equal 555, obj.shop_id
    assert_equal "hello world2", obj.id
    assert_equal true, obj.boolean
  end

  def test_decode_test1
    data = "\b\x96\x01".b
    obj = ProtoBuff::Test1.decode data
    assert_equal 150, obj.a
  end

  def test_decode_negative_int32
    data = ::Test1.encode(Test1.new.tap { |x| x.a = -123 })
    obj = ProtoBuff::Test1.decode data
    assert_equal(-123, obj.a)
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

  def test_default_values_repeated_field
    expected = ::TestRepeatedField.new
    actual = ProtoBuff::TestRepeatedField.new

    assert_equal expected.e.length, actual.e.length
  end

  def test_default_values_test_embedder
    expected = ::TestEmbedder.new
    actual = ProtoBuff::TestEmbedder.new

    assert_equal expected.id, actual.id
    assert_nil expected.value
    assert_nil actual.value
    assert_equal expected.message, actual.message

    expected = ::TestEmbeddee.new
    actual = ProtoBuff::TestEmbeddee.new

    assert_equal expected.value, actual.value
  end

  def test_default_values_message
    expected = ::TestMessage.new
    actual = ProtoBuff::TestMessage.new

    assert_equal expected.id, actual.id
    assert_equal expected.shop_id, actual.shop_id
    assert_equal expected.boolean, actual.boolean
  end

  def test_default_values_test1
    expected = ::Test1.new
    actual = ProtoBuff::Test1.new

    assert_equal expected.a, actual.a
  end

  def test_default_signed
    expected = ::TestSigned.new
    actual = ProtoBuff::TestSigned.new

    assert_equal expected.a, actual.a
  end

  def test_default_string
    expected = ::TestString.new
    actual = ProtoBuff::TestString.new

    assert_equal expected.a, actual.a
  end
end
