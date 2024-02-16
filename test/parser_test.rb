require "helper"

class ParserTest < ProtoBuff::Test
  def test_parse_empty_unit
    ProtoBuff.parse_string('')
  end

  def block_comments
    ProtoBuff.parse_string('syntax = "proto3" /*hey*/;')
    ProtoBuff.parse_string("syntax = \"proto3\"; /*hey\nyou*/ message Foo {}")
    assert_raises { ProtoBuff.parse_string('syntax = "proto3"; /*hi/*') }
    assert_raises { ProtoBuff.parse_string('syntax = "proto3"; /*hi /*nested*/ */') }
  end

  def test_syntax_mode
    ProtoBuff.parse_string('syntax = "proto3";')
    assert_raises { ProtoBuff.parse_string('syntax = "proto0";') }
  end

  def test_option_str
    unit = ProtoBuff.parse_string('option foo_bar = "foobar";')
    assert_equal "foo_bar", unit.options[0].name
    assert_equal "foobar", unit.options[0].value

    # Check that string escaping is working correctly
    unit = ProtoBuff.parse_string('option foo_bar = "foo\nbar";')
    assert_equal "foo_bar", unit.options[0].name
    assert_equal "foo\nbar", unit.options[0].value
  end

  def test_empty_msg
    unit = ProtoBuff.parse_string('syntax = "proto3"; message Foo {}')
    assert_equal 'Foo', unit.messages[0].name
  end

  def test_msg_pos
    unit = ProtoBuff.parse_string('syntax = "proto3"; message Foo {}')
    pos = unit.messages[0].pos
    assert_equal 1, pos.line_no
    assert_equal 20, pos.col_no

    unit = ProtoBuff.parse_string("syntax = \"proto3\";\nmessage Foo {}")
    pos = unit.messages[0].pos

    assert_equal 2, pos.line_no
    assert_equal 1, pos.col_no
  end

  def test_msg_eos
    assert_raises { ProtoBuff.parse_string('message Foo {') }
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

  def test_negative_field_num
    assert_raises { ProtoBuff.parse_string('message Test1 { optional int32 a = -1; }') }
  end

  def test_duplicate_field_num
    assert_raises { ProtoBuff.parse_string('message Test1 { int32 a = 1; int32 b = 1; }') }
  end

  def test_msg_multiple_fields
    unit = ProtoBuff.parse_string('message TestMessage { string id = 1; uint64 shop_id = 2; bool boolean = 3; }')
    assert_equal 3, unit.messages[0].fields.length
    assert_equal 'id', unit.messages[0].fields[0].name
    assert_nil unit.messages[0].fields[0].qualifier
  end

  def test_msg_oneof
    ProtoBuff.parse_string('message Test1 { int32 a = 1; oneof foo { int32 b = 2; int32 c = 3; } }')

    # Duplicate field number
    assert_raises { ProtoBuff.parse_string('message Test1 { int32 a = 1; oneof foo { int32 b = 2; int32 c = 1; } }') }
  end

  def test_enum
    unit = ProtoBuff.parse_string('enum Foo { CONST1 = 0; }')
    assert_equal 'Foo', unit.enums[0].name
  end

  def test_enum_two_fields
    unit = ProtoBuff.parse_string('enum Foo { CONST0 = 0; CONST1 = 1; }')
    assert_equal 'Foo', unit.enums[0].name
    assert_equal 2, unit.enums[0].constants.size
  end

  def test_enum_no_zero_const
    # Should always have an enum constant with value 0
     assert_raises { ProtoBuff.parse_string('enum Foo { CONST0 = 1; }') }
  end

  def test_enum_duplicate
    assert_raises { ProtoBuff.parse_string('enum Foo { CONST0 = 0; CONST1 = 0; }') }
  end

  def test_enum_alias
    unit = ProtoBuff.parse_string('enum Foo { option allow_alias = true; CONST0 = 0; CONST1 = 1; CONST2 = 1; }')
    assert_equal 'Foo', unit.enums[0].name
    assert_equal 3, unit.enums[0].constants.size
  end

  def test_package_name
    unit = ProtoBuff.parse_string('package foo;')
    assert_equal 'foo', unit.package

    unit = ProtoBuff.parse_string('package foo.bar;')
    assert_equal 'foo.bar', unit.package

    unit = ProtoBuff.parse_string('package foo.bar.bif;')
    assert_equal 'foo.bar.bif', unit.package

    assert_raises { ProtoBuff.parse_string('package foo.bar.bif.;') }

    unit = ProtoBuff.parse_string('package .foo.bar; message Test1 { int32 a = 1; }')
    assert_equal '.foo.bar', unit.package
  end

  def test_test_proto_file
    ProtoBuff.parse_file('./test/fixtures/test.proto')
  end
end
