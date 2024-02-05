require "minitest/autorun"
require "proto/test/fixtures/test_pb"

class MessageTest < Minitest::Test
  def decode(bytes)
    obj = TestMessage.new
    # decode bytes
    obj
  end

  def test_decoding
    data = "\n\vhello world\x10\xD2\t".b
    obj = decode data

    assert_equal "hello world", obj.id
    assert_equal 1234, obj.shop_id
    assert_equal false, obj.boolean
  end
end
