require "helper"

class MessageTest < ProtoBuff::Test
  FIXTURE_FILE = File.join(File.dirname(__FILE__), "fixtures/test.proto")
  unit = ProtoBuff.parse_file(FIXTURE_FILE)
  gen = ProtoBuff::CodeGen.new unit

  class_eval gen.to_ruby

  def test_decode_repeated
    data = ::TestRepeatedField.encode(::TestRepeatedField.new.tap { |x|
      x.e[0] = 1
      x.e[1] = 2
      x.e[2] = 3
      x.e[3] = 0xFF
    })

    obj = TestRepeatedField.decode data
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

    obj = TestEmbedder.decode data
    assert_equal 1234, obj.id
    assert_equal 5678, obj.value.value
    assert_equal "hello world", obj.message
  end

  def test_decode_test_message
    data = ::TestMessage.encode(::TestMessage.new.tap { |x|
      x.id = "hello world"
      x.shop_id = 1234
      x.boolean = false
    })

    obj = TestMessage.decode data
    assert_equal 1234, obj.shop_id
    assert_equal "hello world", obj.id
    assert_equal false, obj.boolean

    data = ::TestMessage.encode(::TestMessage.new.tap { |x|
      x.id = "hello world2"
      x.shop_id = 555
      x.boolean = true
    })

    obj = TestMessage.decode data
    assert_equal 555, obj.shop_id
    assert_equal "hello world2", obj.id
    assert_equal true, obj.boolean
  end

  def test_decode_test1
    data = "\b\x96\x01".b
    obj = Test1.decode data
    assert_equal 150, obj.a
  end

  def test_decode_negative_int32
    data = ::Test1.encode(::Test1.new.tap { |x| x.a = -123 })
    obj = Test1.decode data
    assert_equal(-123, obj.a)
  end

  def test_decode_testsigned
    data = ::TestSigned.encode(::TestSigned.new.tap { |x| x.a = -123 })
    obj = TestSigned.decode data
    assert_equal(-123, obj.a)

    data = ::TestSigned.encode(::TestSigned.new.tap { |x| x.a = 4004 })
    obj = TestSigned.decode data
    assert_equal 4004, obj.a
  end

  def test_decode_teststring
    data = ::TestString.encode(::TestString.new.tap { |x| x.a = "foo" })
    obj = TestString.decode data
    assert_equal "foo", obj.a
  end

  def test_default_values_repeated_field
    expected = ::TestRepeatedField.new
    actual = TestRepeatedField.new

    assert_equal expected.e.length, actual.e.length
  end

  def test_default_values_test_embedder
    expected = ::TestEmbedder.new
    actual = TestEmbedder.new

    assert_equal expected.id, actual.id
    assert_nil expected.value
    assert_nil actual.value
    assert_equal expected.message, actual.message

    expected = ::TestEmbeddee.new
    actual = TestEmbeddee.new

    assert_equal expected.value, actual.value
  end

  def test_default_values_message
    expected = ::TestMessage.new
    actual = TestMessage.new

    assert_equal expected.id, actual.id
    assert_equal expected.shop_id, actual.shop_id
    assert_equal expected.boolean, actual.boolean
  end

  def test_default_values_test1
    expected = ::Test1.new
    actual = Test1.new

    assert_equal expected.a, actual.a
  end

  def test_default_signed
    expected = ::TestSigned.new
    actual = TestSigned.new

    assert_equal expected.a, actual.a
  end

  def test_default_string
    expected = ::TestString.new
    actual = TestString.new

    assert_equal expected.a, actual.a
  end
end
