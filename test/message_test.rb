require "minitest/autorun"
require "proto/test/fixtures/test_pb"

module ProtoBuff
  class TestMessage
    def self.decode(bytes)
      obj = ::TestMessage.new
      # decode bytes
      obj
    end
  end

  class Test1
    def self.decode(bytes)
      obj = ::Test1.new
      # decode bytes
      obj
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
    data = "\b\xD2\t".b
    obj = ProtoBuff::Test1.decode data
    assert_equal 1234, obj.a
  end

  def test_encode_test1
    data = "\b\xD2\t".b
    obj = Test1.new
    obj.a = 1234
    assert_equal data, ProtoBuff::Test1.encode(obj)
  end
end
