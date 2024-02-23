# Parser for the protobuf (proto3) language:
# https://protobuf.dev/programming-guides/proto3/
#
# Grammar definition:
# https://protobuf.dev/reference/protobuf/proto3-spec/

# Note: Google has a unittest.proto test file
# We should aim to be able to parse it
# https://github.com/protocolbuffers/protoscope/blob/main/testdata/unittest.proto

require 'set'

module ProtoBuff
  # Position in a source file
  # Numbers start from 1
  class SrcPos
    attr_reader :file_name
    attr_reader :line_no
    attr_reader :col_no

    def initialize(file_name, line_no, col_no)
      @file_name = file_name
      @line_no = line_no
      @col_no = col_no
    end

    def to_s
      if @file_name
        @file_name + "@" + @line_no.to_s + ":" + @col_no.to_s
      else
        @line_no.to_s + ":" + @col_no.to_s
      end
    end
  end

  class ParseError < StandardError
    attr_reader :pos
    def initialize(msg, pos)
      @pos = pos
      super(msg)
    end

    def to_s
      @msg.to_s + "@" + @pos.to_s
    end
  end

  # Whole unit of input (e.g. one source file)
  class Unit < Struct.new(:package, :options, :imports, :messages, :enums)
    def accept(viz)
      viz.visit_unit self
    end
  end

  class Option < Struct.new(:name, :value, :pos)
    def accept(viz)
      viz.visit_option self
    end
  end

  # The messages field is for nested/local message definitions
  class Message < Struct.new(:name, :fields, :messages, :enums, :pos)
    def accept(viz)
      viz.visit_message self
    end

    def fold(viz, seed)
      viz.fold_message self, seed
    end
  end

  class OneOf < Struct.new(:name, :fields, :pos)
    def field?
      false
    end

    def oneof?
      true
    end

    def accept(viz)
      viz.visit_oneof self
    end

    def fold(viz, seed)
      viz.fold_oneof self, seed
    end
  end

  # Represents the type of map<key_type, value_type>
  MapType = Struct.new(:key_type, :value_type)

  # Qualifier is :optional, :required or :repeated
  class Field < Struct.new(:qualifier, :type, :name, :number, :options, :pos)
    def field?
      true
    end

    def oneof?
      false
    end

    def accept(viz)
      viz.visit_field self
    end

    def fold(viz, seed)
      viz.fold_field self, seed
    end

    def optional?
      qualifier == :optional
    end

    def repeated?
      qualifier == :repeated
    end

    VARINT = 0
    I64 = 1
    LEN = 2
    I32 = 5

    def wire_type
      if repeated?
        LEN
      else
        case type
        when "string"
          LEN
        when "int64", "int32", "uint64", "bool", "sint32", "sint64", "uint32"
          VARINT
        when /[A-Z]+\w+/ # FIXME: this doesn't seem right...
          LEN
        else
          raise "Unknown wire type for field #{type}"
        end
      end
    end
  end

  # Enum and enum constants
  class Enum < Struct.new(:name, :constants, :options, :pos)
    def accept(viz)
      viz.visit_enum self
    end
  end
  class Constant < Struct.new(:name, :number, :pos)
    def accept(viz)
      viz.visit_constant self
    end
  end

  # Parse a source string
  def self.parse_string(str)
    parse_unit(Input.new(str))
  end

  # Parse a source file (i.e. some_file.proto)
  def self.parse_file(file_name)
    str = File.read(file_name)
    parse_unit(Input.new(str, file_name))
  end

  # Parse an entire source unit (e.g. input file)
  def self.parse_unit(input)
    package = nil
    options = []
    imports = []
    messages = []
    enums = []

    loop do
      input.eat_ws

      if input.eof?
        break
      end

      pos = input.pos
      ident = input.read_ident

      # Syntax mode
      if ident == "syntax"
        input.expect '='
        input.eat_ws
        mode = input.read_string
        input.expect ';'
        if mode != "proto3"
          raise ParseError.new("syntax mode must be proto3", pos)
        end
      end

      if ident == "package"
        if package != nil
          raise ParseError.new("only one package name can be specified", pos)
        end
        package = parse_package_name(input)
        input.expect ';'
      end

      # Option
      if ident == "option"
        options << parse_option(input, pos)
      end

      # Import
      if ident == "import"
        input.eat_ws
        import_path = input.read_string
        input.expect ';'
        imports << import_path
      end

      # Message definition
      if ident == "message"
        messages << parse_message(input, pos)
      end

      # Enum definition
      if ident == "enum"
        enums << parse_enum(input, pos)
      end
    end

    Unit.new(package, options, imports, messages, enums)
  end

  # Parse the name of a field type
  def self.parse_field_type(input)
    input.eat_ws
    ident = input.read_ident

    if ident == 'map'
      input.expect '<'
      t1 = parse_field_type(input)
      input.expect ','
      t2 = parse_field_type(input)
      input.expect '>'
      return MapType.new(t1, t2)
    end

    type_name = ident
    loop do
      if input.match '.'
        type_name += '.' + input.read_ident
      else
        break
      end
    end

    type_name
  end

  # Parse a package name, e.g. foo.bar.bif
  def self.parse_package_name(input)
    name = ""

    if input.match '.'
      name += '.' + input.read_ident
    else
      name += input.read_ident
    end

    loop do
      if input.match '.'
        name += '.' + input.read_ident
      else
        break
      end
    end

    name
  end

  def self.parse_option_value(input)
    input.eat_ws
    ch = input.peek_ch

    if ch == '"'
      return input.read_string
    elsif (ch >= '0' && ch <= '9') || ch == '-'
      return input.read_int
    elsif input.match "true"
      return true
    elsif input.match "false"
      return false
    end

    raise ParseError.new("unknown option value type", input.pos)
  end

  # Parse a configuration option
  def self.parse_option(input, pos)
    input.eat_ws
    option_name = input.read_ident
    input.expect '='
    value = parse_option_value(input)
    input.expect ';'
    Option.new(option_name, value, pos)
  end

  def self.parse_field_options(input)
    options = {}

    # If there are no options, stop
    if !input.match '['
      return options
    end

    loop do
      input.eat_ws
      opt_name = input.read_ident
      input.expect '='
      opt_value = parse_option_value(input)
      options[opt_name.to_sym] = opt_value

      if input.match ']'
        break
      end

      input.expect ','
    end

    options
  end

  # Parse the body for a message or oneof
  def self.parse_body(input, pos, inside_message)
    fields = []
    messages = []
    enums = []
    reserved = Set.new

    input.expect '{'

    loop do
      if input.match '}'
        break
      end

      # Nested/local message and enum definitions
      if inside_message && (input.match 'message')
        msg_pos = input.pos
        messages << parse_message(input, msg_pos)
        next
      end
      if inside_message && (input.match 'enum')
        enum_pos = input.pos
        enums << parse_enum(input, enum_pos)
        next
      end

      # For now, we just support one single reserved number
      if input.match 'reserved'
        input.eat_ws
        number = input.read_int
        reserved.add(number)
        input.expect ';'
      end

      qualifier = nil
      if inside_message
        if input.match 'optional'
          qualifier = :optional
        elsif input.match 'required'
          qualifier = :required
        elsif input.match 'repeated'
          qualifier = :repeated
        end

        # If this is a oneof field
        oneof_pos = input.pos
        if input.match 'oneof'
          fields << parse_oneof(input, oneof_pos)
          next
        end
      end

      # Field type and name
      input.eat_ws
      field_pos = input.pos
      type = parse_field_type(input)
      input.eat_ws
      name = input.read_ident
      input.expect '='
      input.eat_ws
      number = input.read_int
      options = parse_field_options(input)
      input.expect ';'

      if number < 1 || number > 536_870_911
        raise ParseError.new("field number outside of valid range #{number}", field_pos)
      end

      fields << Field.new(qualifier, type, name, number, options, field_pos)
    end

    # Check that reserved field numbers are not used
    check_reserved_fields = lambda do |fields|
      fields.each do |field|
        if field.instance_of? OneOf
          check_reserved_fields.call(field.fields)
        else
          if reserved.include? field.number
            raise ParseError.new("field #{field.name} uses reserved field number #{field.number}", field.pos)
          end
        end
      end
    end
    check_reserved_fields.call(fields)

    # Check that there are no duplicate field numbers
    nums_used = Set.new
    check_dup_fields = lambda do |fields|
      fields.each do |field|
        if field.instance_of? OneOf
          check_dup_fields.call(field.fields)
        else
          if nums_used.include? field.number
            raise ParseError.new("field number #{field.number} already in use", field.pos)
          end
          nums_used.add(field.number)
        end
      end
    end
    check_dup_fields.call(fields)

    # Check that there are no duplicate field names
    names_used = Set.new
    check_dup_names = lambda do |fields|
      fields.each do |field|
        if field.instance_of? OneOf
          check_dup_names.call(field.fields)
        else
          if names_used.include? field.name
            raise ParseError.new("field name #{field.name} already in use", field.pos)
          end
          names_used.add(field.name)
        end
      end
    end
    check_dup_names.call(fields)

    return fields, messages, enums
  end

  # Parse a message definition
  def self.parse_message(input, pos)
    input.eat_ws
    message_name = input.read_ident
    fields, messages, enums = parse_body(input, pos, inside_message = true)
    Message.new(message_name, fields, messages, enums, pos)
  end

  # Parse a oneof definition
  def self.parse_oneof(input, pos)
    input.eat_ws
    oneof_name = input.read_ident
    fields, _, _ = parse_body(input, pos, inside_message = false)
    OneOf.new(oneof_name, fields, pos)
  end

  # Parse an enum definition
  def self.parse_enum(input, pos)
    constants = []
    options = {}

    input.eat_ws
    enum_name = input.read_ident
    input.expect '{'

    loop do
      if input.match '}'
        break
      end

      if input.match 'option'
        input.eat_ws
        option_name = input.read_ident
        input.expect '='
        value = parse_option_value(input)
        input.expect ';'
        options[option_name.to_sym] = value
        next
      end

      # Constant name and number
      input.eat_ws
      const_pos = input.pos
      name = input.read_ident
      input.expect '='
      input.eat_ws
      number = input.read_int
      input.expect ';'

      if name != name.upcase
        raise ParseError.new("enum constants should be uppercase identifiers", const_pos)
      end

      if constants.size == 0 && number != 0
        raise ParseError.new("the first enum constant should always have value 0", const_pos)
      end

      if number < -0x80_00_00_00 || number > 0x7F_FF_FF_FF
        raise ParseError.new("enum constants should be in int32 range", const_pos)
      end

      # Check for duplicate constant names
      names_taken = Set.new
      constants.each do |cst|
        if names_taken.include? cst.name
          raise ParseError.new("duplicate enum constant name #{cst.name}", cst.pos)
        end
        names_taken.add cst.name
      end

      constants << Constant.new(name, number, const_pos)
    end

    # Check that we don't have duplicate constant numbers
    allow_alias = options.fetch(:allow_alias, false)
    numbers_taken = Set.new
    constants.each do |constant|
      if (numbers_taken.include? constant.number) && !allow_alias
        raise ParseError.new("two constants use the number #{constant.number}", constant.pos)
      end
      numbers_taken.add(constant.number)
    end

    Enum.new(enum_name, constants, options, pos)
  end

  # Represents an input string/file
  # Works as a tokenizer
  class Input
    def initialize(src, file_name = nil)
      @src = src
      @cur_idx = 0
      @line_no = 1
      @col_no = 1
      @file_name = file_name
    end

    # Get the current source position
    def pos
      SrcPos.new(@file_name, @line_no, @col_no)
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
    # Does not read whitespace first
    def match_exact(str)
      if start_with?(str)
        # Use eat_ch to maintain source position tracking
        str.size.times do
          eat_ch
        end
        true
      else
        false
      end
    end

    # Check if the input matches a given string/keyword
    # If there is a match, consume the string
    # Reads whitespace first
    def match(str)
      eat_ws
      match_exact(str)
    end

    # Raise an exception if we can't match a specific string
    def expect(str)
      if !match(str)
        raise ParseError.new("expected \"#{str}\"", pos)
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

      # Keep track of the line and column number
      if ch == "\n"
        @line_no += 1
        @col_no = 1
      elsif ch != "\r"
        @col_no += 1
      end

      ch
    end

    # Consume whitespace
    def eat_ws()
      loop do
        if eof?
          break
        end

        # Single-line comment
        if match_exact("//")
          loop do
            if eof?
              return
            end
            ch = eat_ch
            if ch == "\n"
              break
            end
          end
          next
        end

        # Multi-line (block) comment
        if match_exact("/*")
          loop do
            if eof?
              raise ParseError.new("end of input inside block comment", pos)
            end

            if match_exact("/*")
              raise ParseError.new("encountered '/*' inside block comment", pos)
            end

            if match_exact("*/")
              break
            end

            eat_ch
          end
          next
        end

        ch = peek_ch

        if ch == " " || ch == "\t" || ch == "\n" || ch == "\r"
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
        raise ParseError.new("expected identifier", pos)
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
          raise ParseError.new("unexpected end of input inside string constant", pos)
        end

        # End of string
        if match("\"")
          break
        end

        # TODO: \xHH
        # Hex escape sequence

        # Escape sequences
        if match("\\")
          if match("\?")
            str << "\?"
          elsif match("\\")
            str << "\\"
          elsif match("\'")
            str << "\'"
          elsif match("\"")
            str << "\""
          elsif match("r")
            str << "\r"
          elsif match("n")
            str << "\n"
          elsif match("t")
            str << "\t"
          else
            raise ParseError.new("unknown escape sequence in string constant", pos)
          end
          next
        end

        str << eat_ch
      end

      return str
    end

    # Read an integer constant
    def read_int
      value = 0
      num_digits = 0
      sign = 1
      base = 10

      # Negative number
      if match_exact '-'
        sign = -1
      end

      # Hexadecimal
      if match_exact '0x'
        base = 16
      end

      # For each digit
      loop do
        if eof?
          break
        end

        ch = peek_ch

        if ch >= '0' && ch <= '9'
          digit = ch.getbyte(0) - 0x30
        elsif (base == 16) && (ch >= 'A' && ch <= 'F')
          digit = 10 + (ch.getbyte(0) - 0x41)
        elsif (base == 16) && (ch >= 'a' && ch <= 'f')
          digit = 10 + (ch.getbyte(0) - 0x61)
        else
          break
        end

        # Decimal digit value
        value = base * value + digit
        num_digits += 1
        eat_ch
      end

      if num_digits == 0
        raise ParseError.new("expected integer", pos)
      end

      sign * value
    end
  end
end
