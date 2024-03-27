require "helper"
require "protoboeuf/protobuf/uint64value"

class WellKnownTypesTest < ProtoBoeuf::Test
  def test_uint64
    v = ProtoBoeuf::Protobuf::UInt64Value.new
    assert_equal 0, v.value
  end

  def test_uint64_decode
    data = Google::Protobuf::UInt64Value.encode(Google::Protobuf::UInt64Value.new.tap { |x|
      x.value = 1234
    })
    v = ProtoBoeuf::Protobuf::UInt64Value.decode data
    assert_equal 1234, v.value
  end
end
