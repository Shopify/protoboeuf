# Parser for the protobuf (proto3) language:
# https://protobuf.dev/programming-guides/proto3/

# Note: Google has a unittest.proto test file
# We should aim to be able to parse it
# https://github.com/protocolbuffers/protoscope/blob/main/testdata/unittest.proto

# Notes about protobuf language (these will be removed later):
# - There are // style single-line comments
# - Messages have a list of fields
#   - Fields have field numbers
#   - Fields can be optional, repeated, map (key/value pairs)
#   - Fields can have a default value
# - There are enums, which are integer types
#   - Enum variants have integer values (is this optional?)
#   - There must be a zero value (the default value)
#   - Multiple different enums can share the same value if you set "option allow_alias = true;"
#   - Enumerator constants must be in the range of a 32-bit integer.
#   enum Foo {
#     reserved 2, 15, 9 to 11, 40 to max;
#     reserved "FOO", "BAR";
#   }
# - There's also oneof, which is a kind of union/enum
# - You can import definitions
#   import "myproject/other_protos.proto";

# Represents an input string/file
# Works as a tokenizer
class Input
  def initialize(src)
    @src = src
    @cur_idx = 0
  end

  # Check if we're at the end of the input
  def eof?
    return @cur_idx >= @src.size
  end

  # Check if the input start with a given string
  def start_with?(str)
    return @src[@cur_idx...(@cur_idx + str.size)] == str
  end

  # Check if the input matches a given string/keyword
  # If there is a match, consume the string
  def match(str)
    eat_ws
    if start_with?(str)
      @cur_idx += str.size
      true
    else
      false
    end
  end

  # Raise an exception if we can't match a specific string
  def expect(str)
    if !match(str)
      raise "expected \"#{str}\""
    end
  end

  # Peek at the next input character
  def peek_ch()
    @src[@cur_idx]
  end

  # Consume one character from the input
  def eat_ch()
    ch = @src[@cur_idx]
    @cur_idx += 1
    ch
  end

  # Consume whitespace
  def eat_ws()
    loop do
      if eof?
        break
      end

      ch = peek_ch

      if ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r'
        eat_ch
      else
        break
      end
    end
  end

  # Read an identifier/name, eg:
  # foo
  # bar_bif
  # foo123
  def read_ident
    name = ''

    loop do
      if eof?
        break
      end

      ch = peek_ch

      if !ch.match(/[A-Za-z0-9_]/)
        break
      end

      name << eat_ch
    end

    if name.size == 0
      raise "expected variable name"
    end

    return name
  end

  # Read a string constant, eg:
  # 'foobar'
  def read_string
    str = ''

    # The string must start with an opening quote
    expect '"'

    loop do
      if eof?
        raise "unexpected end of input"
      end

      # End of string
      if match("\"")
        break
      end

      # TODO: more complete support for string escaping
      if match("\\'")
        str << "\'"
        continue
      end

      str << eat_ch
    end

    return str
  end

  # Read an integer constant
  def read_int
    value = 0

    loop do
      if eof?
        raise "unexpected end of input"
      end

      ch = peek_ch

      if ch < '0' || ch > '9'
        break
      end

      # Decimal digit value
      digit = ch.getbyte(0) - 0x30
      value = 10 * value + digit
      eat_ch
    end

    value
  end
end

Unit = Struct.new(:messages)

Message = Struct.new(:name, :fields)

# TODO: repeated fields
Field = Struct.new(:optional, :name, :number)

# Parse an entire source unit (e.g. input file)
def parse_unit(input)
  messages = []

  loop do
    input.eat_ws

    if input.eof?
      break
    end

    ident = input.read_ident

    # Syntax mode
    if ident == "syntax"
      input.eat_ws
      mode = input.read_string
      input.expect ';'
      if mode != "proto3"
        raise "syntax mode must be proto3"
      end
    end

    # Message definition
    if ident == "message"
      parse_message(input)
    end
  end

  Unit.new(messages)
end

def parse_string(str)
  parse_unit(Input.new(str))
end

def parse_file(name)
  raise "TODO"
end

# Parse a message definition
def parse_message(input)
  fields = []

  input.eat_ws
  name = input.read_ident
  input.expect '{'

  loop do
    if input.match '}'
      break
    end

    optional = false
    if input.match 'optional'
      optional = true
    end

    # Field type and name
    input.eat_ws
    type = input.read_ident
    input.eat_ws
    name = input.read_ident
    input.expect '='
    input.eat_ws
    number = input.read_int
    input.expect ';'

    if number < 0 || number > 0xFF_FF_FF_FF
      raise "field number should be in uint32 range"
    end

    fields << Field.new(optional, name, number)
  end

  # TODO: determine if an empty message with no fields is valid protobuf

  Message.new(name, fields)
end

parse_string('')
parse_string('syntax "proto3";')
parse_string('syntax "proto3"; message Foo {}')
parse_string('message Test1 { optional int32 a = 1; }')
parse_string('message TestMessage { string id = 1; uint64 shop_id = 2; bool boolean = 3; }')






# TODO: write some tests, try to parse:
# ./test/fixtures/test.proto








