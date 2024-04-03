require "helper"

class MessageTest < ProtoBoeuf::Test
  FIXTURE_FILE = File.join(File.dirname(__FILE__), "fixtures/test.proto")
  unit = ProtoBoeuf.parse_file(FIXTURE_FILE)
  gen = ProtoBoeuf::CodeGen.new unit

  class_eval gen.to_ruby

  def test_sint64
    data = ::TestSint64.encode(::TestSint64.new.tap { |x|
      x.sint_64 = 12345
    })

    obj = TestSint64.decode data
    assert_equal 12345, obj.sint_64

    data = ::TestSint64.encode(::TestSint64.new.tap { |x|
      x.sint_64 = -2
    })

    obj = TestSint64.decode data
    assert_equal(-2, obj.sint_64)

    data = ::TestSint64.encode(::TestSint64.new.tap { |x|
      x.sint_64 = -0xFFFF_FFFF_FFFF
    })

    obj = TestSint64.decode data
    assert_equal(-0xFFFF_FFFF_FFFF, obj.sint_64)
  end

  def test_int64
    data = ::TestInt64.encode(::TestInt64.new.tap { |x|
      x.int_64 = 12345
    })

    obj = TestInt64.decode data
    assert_equal 12345, obj.int_64

    data = ::TestInt64.encode(::TestInt64.new.tap { |x|
      x.int_64 = -2
    })

    obj = TestInt64.decode data
    assert_equal(-2, obj.int_64)

    data = ::TestInt64.encode(::TestInt64.new.tap { |x|
      x.int_64 = -0xFFFF_FFFF_FFFF
    })

    obj = TestInt64.decode data
    assert_equal(-0xFFFF_FFFF_FFFF, obj.int_64)
  end

  def test_decode_repeated
    data = ::TestRepeatedField.encode(::TestRepeatedField.new.tap { |x|
      x.e[0] = 1
      x.e[1] = 2
      x.e[2] = 3
      x.e[3] = 0xFF
      x.another_value = 0xCAFE
    })

    obj = TestRepeatedField.decode data
    3.times do |i|
      assert_equal i + 1, obj.e[i]
    end

    assert_equal 0xFF, obj.e[3]
    assert_equal 0xCAFE, obj.another_value
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
      x.uuid = ["123e4567-e89b-12d3-a456-426614174000".delete("-")].pack("H*")
    })

    obj = TestMessage.decode data
    assert_equal 1234, obj.shop_id
    assert_equal "hello world", obj.id
    assert_equal false, obj.boolean
    assert_equal "\x12>Eg\xE8\x9B\x12\xD3\xA4VBf\x14\x17@\x00".b, obj.uuid

    data = ::TestMessage.encode(::TestMessage.new.tap { |x|
      x.id = "hello world2"
      x.shop_id = 555
      x.boolean = true
      x.uuid = ["345e4567-e89b-12d3-a456-426614174000".delete("-")].pack("H*")
    })

    obj = TestMessage.decode data
    assert_equal 555, obj.shop_id
    assert_equal "hello world2", obj.id
    assert_equal true, obj.boolean
    assert_equal "4^Eg\xE8\x9B\x12\xD3\xA4VBf\x14\x17@\x00".b, obj.uuid
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

  def test_decode_testbytes
    data = ::TestBytes.encode(::TestBytes.new.tap { |x| x.a = "\x00\x01\x02\x03\x04".b })
    obj = TestBytes.decode data
    assert_equal "\x00\x01\x02\x03\x04".b, obj.a
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

  def test_default_Bytes
    expected = ::TestBytes.new
    actual = TestBytes.new

    assert_equal expected.a, actual.a
  end

  def test_default_string_is_frozen
    obj = TestString.new
    assert_predicate obj.a, :frozen?
  end

  def test_many_optional
    expected = ::ManyOptional.new
    actual = ManyOptional.new

    assert_equal expected.a, actual.a
    refute_predicate expected, :has_a?
    refute_predicate expected, :has_d?
    refute_predicate actual, :has_a?
    refute_predicate actual, :has_d?

    assert_raises { expected.has_c? }
    assert_raises { actual.has_c? }

    expected.a = 123
    actual.a = 123
    expected.d = 456
    actual.d = 456

    assert_predicate expected, :has_a?
    assert_predicate expected, :has_d?
    assert_predicate actual, :has_a?
    assert_predicate actual, :has_d?
  end

  def test_optional_from_binary
    msg = ::ManyOptional.new
    msg.a = 123

    bin = ::ManyOptional.encode(msg)

    # Upstream knows that "a" has been set
    loaded = ::ManyOptional.decode(bin)
    assert_predicate loaded, :has_a?

    # We must match that
    actual = ManyOptional.decode(bin)
    assert_predicate actual, :has_a?
  end

  def test_oneof_methods_set_oneof_field
    msg = TestMessageWithOneOf.new
    assert_equal 0, msg.oneof_u32
    assert_nil msg.oneof_msg
    assert_equal "", msg.oneof_str
    assert_nil msg.oneof_field

    msg.oneof_str = "hello"
    assert_equal "hello", msg.oneof_str
    assert_equal :oneof_str, msg.oneof_field

    msg.oneof_u32 = 123
    assert_equal 123, msg.oneof_u32
    assert_equal :oneof_u32, msg.oneof_field
  end

  def test_oneof_method_signature
    msg = TestMessageWithOneOf.new(oneof_str: "hello")
    assert_equal 0, msg.oneof_u32
    assert_equal :oneof_str, msg.oneof_field
    assert_equal "hello", msg.oneof_str
  end

  def test_oneof_decoding
    msg = ::TestMessageWithOneOf.new(oneof_str: "hello")
    actual = TestMessageWithOneOf.decode(::TestMessageWithOneOf.encode(msg))
    assert_equal "hello", actual.oneof_str
    assert_equal :oneof_str, actual.oneof_field
    assert_equal 0, actual.oneof_u32
  end

  def test_optional_passed_to_constructor
    msg = ManyOptional.new
    assert_equal 0, msg.a
    refute_predicate msg, :has_a?

    msg = ManyOptional.new(a: 0)
    assert_equal 0, msg.a
    assert_predicate msg, :has_a?
  end

  def test_empty_message
    data = ::EmptyMessage.encode(::EmptyMessage.new)

    obj = EmptyMessage.decode data
    assert_kind_of EmptyMessage, obj
  end

  def test_decode_map
    data = ::HasMap.encode(::HasMap.new.tap { |x|
      x.something["a"] = 1
      x.something["b"] = 2
      x.something["c"] = 3
      x.something["d"] = 0xFF
      x.number = 1234
    })

    obj = HasMap.decode data
    assert_equal 1, obj.something["a"]
    assert_equal 2, obj.something["b"]
    assert_equal 3, obj.something["c"]
    assert_equal 0xFF, obj.something["d"]
    assert_equal 1234, obj.number
  end

  def test_decode_repeated_unpacked
    data = ::UnpackedFields.encode(::UnpackedFields.new.tap { |x|
      x.a = 1234
      x.ids[0] = 1
      x.ids[1] = 2
      x.ids[2] = 3
      x.ids[3] = 0xFF
      x.b = 0xCAFE
    })

    obj = UnpackedFields.decode data
    assert_equal 1234, obj.a
    3.times do |i|
      assert_equal i + 1, obj.ids[i]
    end

    assert_equal 0xFF, obj.ids[3]
    assert_equal 0xCAFE, obj.b
  end

  def test_decode_repeated_strings
    data = ::RepeatedStrings.encode(::RepeatedStrings.new.tap { |x|
      x.a = 1234
      x.names[0] = "a"
      x.names[1] = "b"
      x.names[2] = "c"
      x.names[3] = "d"
      x.b = 0xCAFE
    })

    obj = RepeatedStrings.decode data
    assert_equal 1234, obj.a
    assert_equal "a", obj.names[0]
    assert_equal "b", obj.names[1]
    assert_equal "c", obj.names[2]
    assert_equal "d", obj.names[3]
    assert_equal 0xCAFE, obj.b
  end

  def test_decode_repeated_messages
    data = ::RepeatedSubMessages.encode(::RepeatedSubMessages.new(ints:[
      ::TestSint64.new(sint_64: 1),
      ::TestSint64.new(sint_64: 2),
      ::TestSint64.new(sint_64: 3),
      ::TestSint64.new(sint_64: 4),
    ]))

    obj = RepeatedSubMessages.decode data
    4.times do |i|
      assert_equal i + 1, obj.ints[i].sint_64
    end
  end

  def test_default_double
    expected = ::FixedWidthNumbers.new
    actual = FixedWidthNumbers.new
    assert_same expected.a, actual.a
    assert_same expected.b, actual.b
    assert_same expected.c, actual.c
    assert_same expected.d, actual.d
    assert_same expected.e, actual.e
  end

  def test_decode_doubles
    data = ::FixedWidthNumbers.encode(::FixedWidthNumbers.new(a: 1.2, b: 2.3, c: 2, d: 2.0))
    actual = FixedWidthNumbers.decode(data)
    assert_equal 1.2, actual.a
    assert_equal 2.3, actual.b
    assert_equal 2, actual.c
    assert_equal 2.0, actual.d
  end

  def test_embedded_encode
    data = ::ObjWithEmbedded::Embedded.encode(::ObjWithEmbedded::Embedded.new(b: 2, c: 3))
    actual = ObjWithEmbedded::Embedded.decode(data)
    assert_equal 2, actual.b
    assert_equal 3, actual.c
  end

  def test_enum_values
    refute_equal ::SimpleEnum, SimpleEnum
    assert_equal ::SimpleEnum::ZERO, SimpleEnum::ZERO
    assert_equal ::SimpleEnum::ONE, SimpleEnum::ONE
    assert_equal ::SimpleEnum::TWO, SimpleEnum::TWO

    assert_equal ::SimpleEnum.lookup(0), SimpleEnum.lookup(0)
    assert_equal ::SimpleEnum.resolve(:ZERO), SimpleEnum.resolve(:ZERO)
    assert_nil ::SimpleEnum.lookup(10)
    assert_nil SimpleEnum.lookup(10)
  end

  def test_enum_methods
    expected = ::HasEnum.new
    actual = HasEnum.new
    assert_equal expected.a, actual.a

    expected.a = 1
    actual.a = 1

    assert_equal expected.a, actual.a

    expected.a = :TWO
    actual.a = :TWO

    assert_equal expected.a, actual.a

    expected.a = 10
    actual.a = 10

    assert_equal expected.a, actual.a
  end

  def test_enum_new
    expected = ::HasEnum.new(a: :ONE)
    actual = HasEnum.new(a: :ONE)
    assert_equal expected.a, actual.a

    expected = ::HasEnum.new(a: 0)
    actual = HasEnum.new(a: 0)
    assert_equal expected.a, actual.a
  end

  def test_enum_decode
    obj = HasEnum.decode(::HasEnum.encode(::HasEnum.new(a: :ONE)))

    assert_equal :ONE, obj.a
  end

  def test_subenum_values
    refute_equal ::HasSubEnum::Thing, HasSubEnum::Thing
    assert_equal ::HasSubEnum::Thing::BASE, HasSubEnum::Thing::BASE
    assert_equal ::HasSubEnum::Thing::NEAT, HasSubEnum::Thing::NEAT

    assert_equal ::HasSubEnum::Thing.lookup(0), HasSubEnum::Thing.lookup(0)
    assert_equal ::HasSubEnum::Thing.resolve(:BASE), HasSubEnum::Thing.resolve(:BASE)
  end

  def test_subenum_methods
    expected = ::HasSubEnum.new
    actual = HasSubEnum.new
    assert_equal expected.a, actual.a

    expected.a = 1
    actual.a = 1

    assert_equal expected.a, actual.a

    expected.a = :BASE
    actual.a = :BASE

    assert_equal expected.a, actual.a

    expected.a = 10
    actual.a = 10

    assert_equal expected.a, actual.a
  end

  def test_translate_known_type_bool
    data = ::HasKnownTypeBool.encode(::HasKnownTypeBool.new.tap { |x|
      x.id = Google::Protobuf::BoolValue.new(value: true)
    })

    instance = HasKnownTypeBool.decode(data)
    assert_kind_of ::ProtoBoeuf::Protobuf::BoolValue, instance.id
    assert_equal true, instance.id.value
  end

  def test_translate_known_type_int32
    data = ::HasKnownTypeInt32.encode(::HasKnownTypeInt32.new.tap { |x|
      x.id = Google::Protobuf::Int32Value.new(value: -123456)
    })

    instance = HasKnownTypeInt32.decode(data)
    assert_kind_of ::ProtoBoeuf::Protobuf::Int32Value, instance.id
    assert_equal -123456, instance.id.value
  end

  def test_translate_known_type_int64
    data = ::HasKnownTypeInt64.encode(::HasKnownTypeInt64.new.tap { |x|
      x.id = Google::Protobuf::Int64Value.new(value: -123456)
    })

    instance = HasKnownTypeInt64.decode(data)
    assert_kind_of ::ProtoBoeuf::Protobuf::Int64Value, instance.id
    assert_equal -123456, instance.id.value
  end

  def test_translate_known_type_uint32
    data = ::HasKnownTypeUInt32.encode(::HasKnownTypeUInt32.new.tap { |x|
      x.id = Google::Protobuf::UInt32Value.new(value: 123456)
    })

    instance = HasKnownTypeUInt32.decode(data)
    assert_kind_of ::ProtoBoeuf::Protobuf::UInt32Value, instance.id
    assert_equal 123456, instance.id.value
  end

  def test_translate_known_type_uint64
    data = ::HasKnownTypeUInt64.encode(::HasKnownTypeUInt64.new.tap { |x|
      x.id = Google::Protobuf::UInt64Value.new(value: 123456)
    })

    instance = HasKnownTypeUInt64.decode(data)
    assert_kind_of ::ProtoBoeuf::Protobuf::UInt64Value, instance.id
    assert_equal 123456, instance.id.value
  end

  def test_translate_known_type_float
    data = ::HasKnownTypeFloat.encode(::HasKnownTypeFloat.new.tap { |x|
      x.id = Google::Protobuf::FloatValue.new(value: 123.5)
    })

    instance = HasKnownTypeFloat.decode(data)
    assert_kind_of ::ProtoBoeuf::Protobuf::FloatValue, instance.id
    assert_equal 123.5, instance.id.value
  end

  def test_translate_known_type_double
    data = ::HasKnownTypeDouble.encode(::HasKnownTypeDouble.new.tap { |x|
      x.id = Google::Protobuf::DoubleValue.new(value: 123.75)
    })

    instance = HasKnownTypeDouble.decode(data)
    assert_kind_of ::ProtoBoeuf::Protobuf::DoubleValue, instance.id
    assert_equal 123.75, instance.id.value
  end

  def test_translate_known_type_string
    data = ::HasKnownTypeString.encode(::HasKnownTypeString.new.tap { |x|
      x.id = Google::Protobuf::StringValue.new(value: "foobar bif")
    })

    instance = HasKnownTypeString.decode(data)
    assert_kind_of ::ProtoBoeuf::Protobuf::StringValue, instance.id
    assert_equal "foobar bif", instance.id.value
  end

  def test_translate_known_type_bytes
    data = ::HasKnownTypeBytes.encode(::HasKnownTypeBytes.new.tap { |x|
      x.id = Google::Protobuf::BytesValue.new(value: "string of bytes")
    })

    instance = HasKnownTypeBytes.decode(data)
    assert_kind_of ::ProtoBoeuf::Protobuf::BytesValue, instance.id
    assert_equal "string of bytes", instance.id.value
  end

  def test_translate_known_type_timestamp
    data = ::HasKnownTypeTimestamp.encode(::HasKnownTypeTimestamp.new.tap { |x|
      x.t = Google::Protobuf::Timestamp.new(seconds: 5555, nanos: 3337)
    })

    instance = HasKnownTypeTimestamp.decode(data)
    assert_kind_of ::ProtoBoeuf::Protobuf::Timestamp, instance.t
    assert_equal 5555, instance.t.seconds
    assert_equal 3337, instance.t.nanos
  end

  def test_encode_bool
    code = ProtoBoeuf.parse_string <<-eoboeuf
syntax = "proto3";

message BoolValue {
  bool value = 1;
}
    eoboeuf

    m = Module.new { class_eval code.to_ruby }

    # False
    actual = m::BoolValue.encode m::BoolValue.new(value: false)
    expected = ::Google::Protobuf::BoolValue.encode(::Google::Protobuf::BoolValue.new(value: false))
    assert_equal expected, actual

    # True
    actual = m::BoolValue.encode m::BoolValue.new(value: true)
    expected = ::Google::Protobuf::BoolValue.encode(::Google::Protobuf::BoolValue.new(value: true))
    assert_equal expected, actual
  end

  def test_encode_uint32
    code = ProtoBoeuf.parse_string <<-eoboeuf
syntax = "proto3";

message UInt32Value {
  uint32 value = 1;
}
    eoboeuf

    m = Module.new { class_eval code.to_ruby }

    [0, 12, 0xFF, 0xFFFF_FFFF].each do |n|
      actual = m::UInt32Value.encode m::UInt32Value.new(value: n)
      expected = ::Google::Protobuf::UInt32Value.encode(::Google::Protobuf::UInt32Value.new(value: n))
      assert_equal expected, actual
    end
  end

  def test_encode_uint64
    code = ProtoBoeuf.parse_string <<-eoboeuf
syntax = "proto3";

message UInt64Value {
  uint64 value = 1;
}
    eoboeuf

    m = Module.new { class_eval code.to_ruby }

    [0, 12, 0xFF, 0xFFFF_FFFF_FFFF_FFFF].each do |n|
      actual = m::UInt64Value.encode m::UInt64Value.new(value: n)
      expected = ::Google::Protobuf::UInt64Value.encode(::Google::Protobuf::UInt64Value.new(value: n))
      assert_equal expected, actual
    end
  end


end
