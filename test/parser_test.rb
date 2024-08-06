require "helper"

class ParserTest < ProtoBoeuf::Test
  def test_parse_empty_unit
    parse_string('')
  end

  def block_comments
    parse_string('syntax = "proto3" /*hey*/;')
    parse_string("syntax = \"proto3\"; /*hey\nyou*/ message Foo {}")
    assert_raises { parse_string('syntax = "proto3"; /*hi/*') }
    assert_raises { parse_string('syntax = "proto3"; /*hi /*nested*/ */') }
  end

  def test_syntax_mode
    parse_string('syntax = "proto3";')
    assert_raises { parse_string('syntax = "proto0";') }
  end

  def test_option_str
    unit = parse_string('option foo_bar = "foobar";')
    assert_equal "foo_bar", unit.options[0].name
    assert_equal "foobar", unit.options[0].value

    # Check that string escaping is working correctly
    unit = parse_string('option foo_bar = "foo\nbar";')
    assert_equal "foo_bar", unit.options[0].name
    assert_equal "foo\nbar", unit.options[0].value
  end

  def test_empty_msg
    unit = parse_string('syntax = "proto3"; message Foo {}')
    assert_equal 'Foo', unit.message_type[0].name
  end

  def test_msg_pos
    unit = parse_string('syntax = "proto3"; message Foo {}')
    pos = unit.message_type[0].pos
    assert_equal 1, pos.line_no
    assert_equal 20, pos.col_no

    unit = parse_string("syntax = \"proto3\";\nmessage Foo {}")
    pos = unit.message_type[0].pos

    assert_equal 2, pos.line_no
    assert_equal 1, pos.col_no
  end

  def test_msg_eos
    assert_raises { parse_string('message Foo {') }
  end

  def test_regress_newline
    parse_string("syntax = \"proto3\";\nmessage Foo {}")
  end

  def test_regress_two_comments
    unit = parse_string("syntax = \"proto3\";// Comment\n//Another comment\nmessage Foo {}")
    assert_equal 'Foo', unit.message_type[0].name
  end

  def test_msg_optional
    unit = parse_string('message Test1 { optional int32 a = 1; }')
    assert_equal 'Test1', unit.message_type[0].name
    assert_equal 'a', unit.message_type[0].field[0].name
    assert_equal :optional, unit.message_type[0].field[0].qualifier
  end

  def test_hex_field_num
    unit = parse_string('message Test1 { int32 a = 0xFF; }')
    assert_equal 0xFF, unit.message_type[0].field[0].number
    unit = parse_string('message Test1 { int32 a = 0xaa; }')
    assert_equal 0xAA, unit.message_type[0].field[0].number
  end

  def test_message_reserved
    parse_string('message Test1 { int32 a = 1; reserved 2; }')
    assert_raises { parse_string('message Test1 { int32 a = 1; reserved 1; }') }
    assert_raises { parse_string('message Test1 { int32 a = 2; reserved 1 to 10; }') }
    assert_raises { parse_string('message Test1 { int32 a = 2; reserved 1 to max; }') }
    assert_raises { parse_string('message Test1 { int32 a = 3; reserved 1, 2, 3, 4; }') }
  end

  def test_negative_field_num
    assert_raises { parse_string('message Test1 { optional int32 a = -1; }') }
  end

  def test_duplicate_field_num
    assert_raises { parse_string('message Test1 { int32 a = 1; int32 b = 1; }') }
  end

  def test_duplicate_field_names
    assert_raises { parse_string('message Test1 { int32 a = 1; int32 a = 2; }') }
    assert_raises { parse_string('message Test1 { int32 a = 1; oneof { int32 a = 2; } }') }
  end

  def test_duplicate_enum_const_names
    assert_raises { parse_string('message Enum { FOO=1; FOO=2; }') }
  end

  def test_msg_multiple_fields
    unit = parse_string('message TestMessage { string id = 1; uint64 shop_id = 2; bool boolean = 3; }')
    assert_equal 3, unit.message_type[0].field.length
    assert_equal 'id', unit.message_type[0].field[0].name
    assert_nil unit.message_type[0].field[0].qualifier
  end

  def test_msg_map_type
    parse_string('message Test1 { map<int64, int64> imf = 1; }')
    parse_string('message Test1 { map<string, google.protobuf.UInt64Value> mf = 1; }')
  end

  def test_msg_oneof
    parse_string('message Test1 { int32 a = 1; oneof foo { int32 b = 2; int32 c = 3; } }')

    # Duplicate field number
    assert_raises { parse_string('message Test1 { int32 a = 1; oneof foo { int32 b = 2; int32 c = 1; } }') }
  end

  def test_enum
    unit = parse_string('enum Foo { CONST1 = 0; }')
    assert_equal 'Foo', unit.enum_type[0].name
  end

  def test_enum_negative
    # Enum with a negative constant value
    parse_string('enum Foo { FOO = 0; BAR = -1; }')
  end

  def test_enum_two_fields
    unit = parse_string('enum Foo { CONST0 = 0; CONST1 = 1; }')
    assert_equal 'Foo', unit.enum_type[0].name
    assert_equal 2, unit.enum_type[0].constants.size
  end

  def test_enum_collision
    assert_raises { parse_string('enum Foo1 { BAR=0; } enum Foo2 { BAR=0; }') }

    parse_string('message Msg { enum Foo1 { BAR=0; } enum Foo2 { BAR2=0; } }')
    assert_raises { parse_string('message Msg { enum Foo1 { BAR=0; } enum Foo2 { BAR=0; } }') }
  end

  def test_enum_zero_const
    # Should always have an enum constant with value 0
     assert_raises { parse_string('enum Foo { CONST0 = 1; }') }

     # The first constant needs to have value 0
     assert_raises { parse_string('enum Foo { BAR = 1; FOO = 0; }') }
  end

  def test_enum_duplicate
    assert_raises { parse_string('enum Foo { CONST0 = 0; CONST1 = 0; }') }
  end

  def test_enum_alias
    unit = parse_string('enum Foo { option allow_alias = true; CONST0 = 0; CONST1 = 1; CONST2 = 1; }')
    assert_equal 'Foo', unit.enum_type[0].name
    assert_equal 3, unit.enum_type[0].constants.size
  end

  def test_hex_enum_const
    unit = parse_string('enum Foo { FOO = 0; BAR = -0xBA; }')
    assert_equal 'Foo', unit.enum_type[0].name
    assert_equal (-0xBA), unit.enum_type[0].constants[1].number
  end

  def test_enum_reserved
    parse_string('enum Foo { C0 = 0; C1 = 1; reserved 5; }')
    assert_raises { parse_string('enum Foo { C0 = 0; C1 = 1; reserved 1; }') }
    assert_raises { parse_string('enum Foo { C0 = 0; C1 = 5; reserved 1 to 10; }') }
    assert_raises { parse_string('enum Foo { C0 = 0; C1 = 5; reserved 2 to max; }') }
  end

  def test_package_name
    unit = parse_string('package foo;')
    assert_equal 'foo', unit.package

    unit = parse_string('package foo.bar;')
    assert_equal 'foo.bar', unit.package

    unit = parse_string('package foo.bar.bif;')
    assert_equal 'foo.bar.bif', unit.package

    assert_raises { parse_string('package foo.bar.bif.;') }

    unit = parse_string('package .foo.bar; message Test1 { int32 a = 1; }')
    assert_equal '.foo.bar', unit.package
  end

  def test_test_proto_file
    unit = parse_file('./test/fixtures/test.proto')
    assert_equal true, (unit.message_type[0].pos.file_name.end_with? 'test.proto')
  end

  private

  def parse_string(str)
    ProtoBoeuf.parse_string(str).file.first
  end

  def parse_file(str)
    ProtoBoeuf.parse_file(str).file.first
  end
end
