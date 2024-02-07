require "minitest/autorun"
require "minitest/color"
require "proto/test/fixtures/test_pb"
require "protobuff/parser"

class MessageTest < Minitest::Test
  def test_parse_empty_unit
    ProtoBuff.parse_string('')
  end

  def test_syntax_mode
    ProtoBuff.parse_string('syntax = "proto3";')
  end

  def test_empty_msg
    unit = ProtoBuff.parse_string('syntax = "proto3"; message Foo {}')
    assert_equal 'Foo', unit.messages[0].name
  end

  def test_regress_newline
    ProtoBuff.parse_string("syntax = \"proto3\";\nmessage Foo {}")
  end

  def test_regress_two_comments
    unit = ProtoBuff.parse_string("syntax = \"proto3\";// Comment\n//Another comment\nmessage Foo {}")
    assert_equal 'Foo', unit.messages[0].name
  end

  def test_msg_optional
    unit = ProtoBuff.parse_string('message Test1 { optional int32 a = 1; }')
    assert_equal 'Test1', unit.messages[0].name
    assert_equal 'a', unit.messages[0].fields[0].name
    assert_equal :optional, unit.messages[0].fields[0].qualifier
  end

  def test_msg_multiple_fields
    unit = ProtoBuff.parse_string('message TestMessage { string id = 1; uint64 shop_id = 2; bool boolean = 3; }')
    assert_equal 3, unit.messages[0].fields.length
    assert_equal 'id', unit.messages[0].fields[0].name
    assert_equal :optional, unit.messages[0].fields[0].qualifier
  end

  def test_test_proto_file
    ProtoBuff.parse_file('./test/fixtures/test.proto')
  end





end
