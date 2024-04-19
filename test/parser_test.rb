require "helper"

class ParserTest < ProtoBoeuf::Test
  def test_parse_empty_unit
    ProtoBoeuf.parse_string('')
  end

  def block_comments
    ProtoBoeuf.parse_string('syntax = "proto3" /*hey*/;')
    ProtoBoeuf.parse_string("syntax = \"proto3\"; /*hey\nyou*/ message Foo {}")
    assert_raises { ProtoBoeuf.parse_string('syntax = "proto3"; /*hi/*') }
    assert_raises { ProtoBoeuf.parse_string('syntax = "proto3"; /*hi /*nested*/ */') }
  end

  def test_syntax_mode
    ProtoBoeuf.parse_string('syntax = "proto3";')
    assert_raises { ProtoBoeuf.parse_string('syntax = "proto0";') }
  end

  def test_option_str
    unit = ProtoBoeuf.parse_string('option foo_bar = "foobar";')
    assert_equal "foo_bar", unit.options[0].name
    assert_equal "foobar", unit.options[0].value

    # Check that string escaping is working correctly
    unit = ProtoBoeuf.parse_string('option foo_bar = "foo\nbar";')
    assert_equal "foo_bar", unit.options[0].name
    assert_equal "foo\nbar", unit.options[0].value
  end

  def test_empty_msg
    unit = ProtoBoeuf.parse_string('syntax = "proto3"; message Foo {}')
    assert_equal 'Foo', unit.messages[0].name
  end

  def test_msg_pos
    unit = ProtoBoeuf.parse_string('syntax = "proto3"; message Foo {}')
    pos = unit.messages[0].pos
    assert_equal 1, pos.line_no
    assert_equal 20, pos.col_no

    unit = ProtoBoeuf.parse_string("syntax = \"proto3\";\nmessage Foo {}")
    pos = unit.messages[0].pos

    assert_equal 2, pos.line_no
    assert_equal 1, pos.col_no
  end

  def test_msg_eos
    assert_raises { ProtoBoeuf.parse_string('message Foo {') }
  end

  def test_regress_newline
    ProtoBoeuf.parse_string("syntax = \"proto3\";\nmessage Foo {}")
  end

  def test_regress_two_comments
    unit = ProtoBoeuf.parse_string("syntax = \"proto3\";// Comment\n//Another comment\nmessage Foo {}")
    assert_equal 'Foo', unit.messages[0].name
  end

  def test_msg_optional
    unit = ProtoBoeuf.parse_string('message Test1 { optional int32 a = 1; }')
    assert_equal 'Test1', unit.messages[0].name
    assert_equal 'a', unit.messages[0].fields[0].name
    assert_equal :optional, unit.messages[0].fields[0].qualifier
  end

  def test_hex_field_num
    unit = ProtoBoeuf.parse_string('message Test1 { int32 a = 0xFF; }')
    assert_equal 0xFF, unit.messages[0].fields[0].number
    unit = ProtoBoeuf.parse_string('message Test1 { int32 a = 0xaa; }')
    assert_equal 0xAA, unit.messages[0].fields[0].number
  end

  def test_message_reserved
    ProtoBoeuf.parse_string('message Test1 { int32 a = 1; reserved 2; }')
    assert_raises { ProtoBoeuf.parse_string('message Test1 { int32 a = 1; reserved 1; }') }
    assert_raises { ProtoBoeuf.parse_string('message Test1 { int32 a = 2; reserved 1 to 10; }') }
    assert_raises { ProtoBoeuf.parse_string('message Test1 { int32 a = 2; reserved 1 to max; }') }
    assert_raises { ProtoBoeuf.parse_string('message Test1 { int32 a = 3; reserved 1, 2, 3, 4; }') }
  end

  def test_negative_field_num
    assert_raises { ProtoBoeuf.parse_string('message Test1 { optional int32 a = -1; }') }
  end

  def test_duplicate_field_num
    assert_raises { ProtoBoeuf.parse_string('message Test1 { int32 a = 1; int32 b = 1; }') }
  end

  def test_duplicate_field_names
    assert_raises { ProtoBoeuf.parse_string('message Test1 { int32 a = 1; int32 a = 2; }') }
    assert_raises { ProtoBoeuf.parse_string('message Test1 { int32 a = 1; oneof { int32 a = 2; } }') }
  end

  def test_duplicate_enum_const_names
    assert_raises { ProtoBoeuf.parse_string('message Enum { FOO=1; FOO=2; }') }
  end

  def test_msg_multiple_fields
    unit = ProtoBoeuf.parse_string('message TestMessage { string id = 1; uint64 shop_id = 2; bool boolean = 3; }')
    assert_equal 3, unit.messages[0].fields.length
    assert_equal 'id', unit.messages[0].fields[0].name
    assert_nil unit.messages[0].fields[0].qualifier
  end

  def test_msg_map_type
    ProtoBoeuf.parse_string('message Test1 { map<int64, int64> imf = 1; }')
    ProtoBoeuf.parse_string('message Test1 { map<string, google.protobuf.UInt64Value> mf = 1; }')
  end

  def test_msg_oneof
    ProtoBoeuf.parse_string('message Test1 { int32 a = 1; oneof foo { int32 b = 2; int32 c = 3; } }')

    # Duplicate field number
    assert_raises { ProtoBoeuf.parse_string('message Test1 { int32 a = 1; oneof foo { int32 b = 2; int32 c = 1; } }') }
  end

  def test_enum
    unit = ProtoBoeuf.parse_string('enum Foo { CONST1 = 0; }')
    assert_equal 'Foo', unit.enums[0].name
  end

  def test_enum_negative
    # Enum with a negative constant value
    ProtoBoeuf.parse_string('enum Foo { FOO = 0; BAR = -1; }')
  end

  def test_enum_two_fields
    unit = ProtoBoeuf.parse_string('enum Foo { CONST0 = 0; CONST1 = 1; }')
    assert_equal 'Foo', unit.enums[0].name
    assert_equal 2, unit.enums[0].constants.size
  end

  def test_enum_collision
    assert_raises { ProtoBoeuf.parse_string('enum Foo1 { BAR=0; } enum Foo2 { BAR=0; }') }

    ProtoBoeuf.parse_string('message Msg { enum Foo1 { BAR=0; } enum Foo2 { BAR2=0; } }')
    assert_raises { ProtoBoeuf.parse_string('message Msg { enum Foo1 { BAR=0; } enum Foo2 { BAR=0; } }') }
  end

  def test_enum_zero_const
    # Should always have an enum constant with value 0
     assert_raises { ProtoBoeuf.parse_string('enum Foo { CONST0 = 1; }') }

     # The first constant needs to have value 0
     assert_raises { ProtoBoeuf.parse_string('enum Foo { BAR = 1; FOO = 0; }') }
  end

  def test_enum_duplicate
    assert_raises { ProtoBoeuf.parse_string('enum Foo { CONST0 = 0; CONST1 = 0; }') }
  end

  def test_enum_alias
    unit = ProtoBoeuf.parse_string('enum Foo { option allow_alias = true; CONST0 = 0; CONST1 = 1; CONST2 = 1; }')
    assert_equal 'Foo', unit.enums[0].name
    assert_equal 3, unit.enums[0].constants.size
  end

  def test_hex_enum_const
    unit = ProtoBoeuf.parse_string('enum Foo { FOO = 0; BAR = -0xBA; }')
    assert_equal 'Foo', unit.enums[0].name
    assert_equal (-0xBA), unit.enums[0].constants[1].number
  end

  def test_package_name
    unit = ProtoBoeuf.parse_string('package foo;')
    assert_equal 'foo', unit.package

    unit = ProtoBoeuf.parse_string('package foo.bar;')
    assert_equal 'foo.bar', unit.package

    unit = ProtoBoeuf.parse_string('package foo.bar.bif;')
    assert_equal 'foo.bar.bif', unit.package

    assert_raises { ProtoBoeuf.parse_string('package foo.bar.bif.;') }

    unit = ProtoBoeuf.parse_string('package .foo.bar; message Test1 { int32 a = 1; }')
    assert_equal '.foo.bar', unit.package
  end

  def test_test_proto_file
    unit = ProtoBoeuf.parse_file('./test/fixtures/test.proto')
    assert_equal true, (unit.messages[0].pos.file_name.end_with? 'test.proto')
  end
end
