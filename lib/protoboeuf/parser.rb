# frozen_string_literal: true
# Parser for the protobuf (proto3) language:
# https://protobuf.dev/programming-guides/proto3/
#
# Grammar definition:
# https://protobuf.dev/reference/protobuf/proto3-spec/

# Note: Google has a unittest.proto test file
# We should aim to be able to parse it
# https://github.com/protocolbuffers/protoscope/blob/main/testdata/unittest.proto

require 'set'

module ProtoBoeuf
  class Parser
    class Error < StandardError
      attr_reader :pos

      def initialize(msg, pos)
        @pos = pos
        super(msg)
      end

      def to_s
        "#{super}@#{@pos}"
      end
    end

    class SyntaxVersionError < Error
    end
  end

  module AST
    class FileDescriptorSet
      attr_reader :file

      def initialize(files)
        @file = files
      end

      def accept(viz)
        viz.visit_file_descriptor_set(self)
      end

      def to_ruby
        ProtoBoeuf::CodeGen.new(self).to_ruby
      end
    end

    OneOfDescriptor = Struct.new(:name)

    class FileOptions
      def initialize
        @options = []
      end

      def ruby_package
        @options.find { |opt| opt.name == __method__.to_s }&.value
      end

      def <<(option)
        @options << option
      end

      def [](i)
        @options[i]
      end
    end

    MessageOptions = Struct.new(:map_entry)
    FieldOptions = Struct.new(:packed, :deprecated)
  end

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
        "#{@file_name}@#{@line_no}:#{@col_no}"
      else
        "#{@line_no}:#{@col_no}"
      end
    end
  end

  # Whole unit of input (e.g. one source file)
  class Unit < Struct.new(:package, :options, :imports, :message_type, :enum_type, :syntax)
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
  class Message < Struct.new(:name, :field, :messages, :enum_type, :oneof_decl, :nested_type, :options, :pos)
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
  class Field < Struct.new(:label, :type_name, :type, :name, :number, :options, :pos, :enum, :oneof_index, :proto3_optional)
    def has_oneof_index?
      oneof_index || false
    end

    def accept(viz)
      viz.visit_field self
    end

    def fold(viz, seed)
      viz.fold_field self, seed
    end
  end

  # Enum and enum constants
  class Enum < Struct.new(:name, :value, :options, :pos)
    def accept(viz)
      viz.visit_enum self
    end
  end
  class Constant < Struct.new(:name, :number, :pos)
    def accept(viz)
      viz.visit_constant self
    end
  end

  # Check for duplicate enum constant names
  def self.check_enum_collision(enums)
    names = Set.new
    enums.each do |enum|
      enum.value.each do |const|
        unless names.add? const.name
          raise Parser::Error.new("duplicate enum constant name #{const.name}", const.pos)
        end
      end
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
    options = nil
    imports = []
    messages = []
    enums = []
    proto3 = false

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
          raise Parser::SyntaxVersionError.new("syntax mode must be proto3", pos)
        end
        proto3 = true

      elsif ident == "package"
        if package != nil
          raise Parser::Error.new("only one package name can be specified", pos)
        end
        package = parse_package_name(input)
        input.expect ';'

      # Option
      elsif ident == "option"
        options ||= AST::FileOptions.new
        options << parse_option(input, pos)

      # Import
      elsif ident == "import"
        input.eat_ws
        import_path = input.read_string
        input.expect ';'
        imports << import_path

      # Message definition
      elsif ident == "message"
        messages << parse_message(input, pos, enums, messages, [], proto3)

      # Enum definition
      elsif ident == "enum"
        enums << parse_enum(input, pos)
      end
    end

    check_enum_collision(enums)
    AST::FileDescriptorSet.new [Unit.new(package, options, imports, messages, enums, "proto3")]
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
    while input.match '.'
      type_name << '.' << input.read_ident
    end

    type_name
  end

  # Parse a package name, e.g. .foo.bar.bif
  def self.parse_package_name(input)
    name = +""

    if input.match '.'
      name << '.' << input.read_ident
    else
      name << input.read_ident
    end

    while input.match '.'
      name << '.' << input.read_ident
    end

    name
  end

  # Parse a composite name, e.g. foo.bar.bif
  def self.parse_composite_name(input)
    name = +""
    name << input.read_ident
    while input.match '.'
      name << '.' << input.read_ident
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
    else
      return input.read_ident
    end

    raise Parser::Error.new("unknown option value type", input.pos)
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
      return nil
    end

    loop do
      input.eat_ws

      # Extension options are in parentheses, e.g.
      # uint32 key = 1 [(google.api.field_behavior) = REQUIRED];
      if input.match '('
        opt_name = parse_composite_name(input)
        input.expect ')'
      else
        opt_name = parse_composite_name(input)
      end

      input.expect '='
      opt_value = parse_option_value(input)
      options[opt_name.to_sym] = opt_value

      if input.match ']'
        break
      end

      input.expect ','
    end

    AST::FieldOptions.new(options[:packed], options[:deprecated])
  end

  # Parse the reserved directive, e.g.
  # reserved 2;
  # reserved 2 to 50;
  # reserved 2 to max;
  # reserved 2, 5 to 10;
  # Returns a list of integer ranges
  def self.parse_reserved(input)
    ranges = []

    loop do
      input.eat_ws

      min_val = input.read_int

      if input.match "to"
        if input.match "max"
          ranges << (min_val..)
        else
          input.eat_ws
          max_val = input.read_int
          ranges << (min_val..max_val)
        end
      else
        ranges << min_val
      end

      if input.match ';'
        break;
      end

      input.expect ',';
    end

    ranges
  end

  # Parse the body for a message or oneof
  def self.parse_body(input, pos, inside_message, top_enums, top_messages, name_stack, oneof_decls, is_proto3)
    fields = []
    messages = []
    enums = []
    reserved = []
    nested_type = []

    input.expect '{'

    until input.match '}'
      # Nested/local message and enum definitions
      if inside_message && (input.match 'message')
        msg_pos = input.pos
        nested_type << parse_message(input, msg_pos, top_enums, top_messages, name_stack, is_proto3)
        next
      end
      if inside_message && (input.match 'enum')
        enum_pos = input.pos
        enums << parse_enum(input, enum_pos)
        next
      end

      if input.match 'reserved'
        reserved.concat(parse_reserved(input))
        next
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
          oneof = parse_oneof(input, oneof_pos, top_enums, top_messages, name_stack, oneof_decls, is_proto3)
          # fix oneof field names
          oneof.fields.each do |field|
            if field.type_name.count(".") == 1
              type = field.type_name.delete_prefix(".")
              field.type_name = qualify(top_messages + top_enums, nested_type + enums, name_stack, type)
            end
          end
          fields.concat oneof.fields
          oneof_decls << oneof
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
        raise Parse::Error.new("field number outside of valid range #{number}", field_pos)
      end

      if type.is_a?(MapType)
        key_field = Field.new(:LABEL_OPTIONAL,
          qualify(top_messages + top_enums, nested_type + enums, name_stack, type.key_type),
          get_type(type.key_type, top_enums + enums),
          "key",
          1,
          nil,
          field_pos,
          nil,
          nil)

        value_field = Field.new(:LABEL_OPTIONAL,
          qualify(top_messages + top_enums, nested_type + enums, name_stack, type.value_type),
          get_type(type.value_type, top_enums + enums),
          "value",
          2,
          nil,
          field_pos,
          nil,
          nil)

        msg_options = AST::MessageOptions.new(true)

        derived_message_name = name.split("_").map { |part|
          part[0] = part[0].upcase
          part
        }.join + "Entry"

        nested_msg = Message.new(derived_message_name,
          [key_field, value_field],
          nil,
          [],
          [],
          [],
          msg_options,
          field_pos)

        nested_type << nested_msg

        map_field = Field.new(
          label(:repeated),
          qualify(top_messages + top_enums, nested_type, name_stack, derived_message_name),
          get_type(type, top_enums + enums),
          name,
          number,
          options, field_pos, nil, nil)

        fields << map_field
      else
        if qualifier == :optional && is_proto3
          fields << Field.new(label(qualifier), qualify(top_messages + top_enums, nested_type + enums, name_stack, type), get_type(type, top_enums + enums), name, number, options, field_pos, nil, nil, is_proto3)
        else
          if inside_message
            fields << Field.new(label(qualifier), qualify(top_messages + top_enums, nested_type + enums, name_stack, type), get_type(type, top_enums + enums), name, number, options, field_pos, nil, nil, false)
          else
            fields << Field.new(label(qualifier), qualify(top_messages + top_enums, nested_type + enums, name_stack, type), get_type(type, top_enums + enums), name, number, options, field_pos, nil, oneof_decls.length, false)
          end
        end
      end
    end

    # Check that reserved field numbers are not used
    check_reserved_fields = lambda do |fields|
      fields.each do |field|
        if field.instance_of? OneOf
          check_reserved_fields.call(field.fields)
        else
          # For each reserved range
          reserved.each do |r|
            if (r.respond_to?(:include?) && r.include?(field.number)) || r == field.number
              raise Parse::Error.new("field #{field.name} uses reserved field number #{field.number}", field.pos)
            end
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
            raise Parse::Error.new("field number #{field.number} already in use", field.pos)
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
            raise Parse::Error.new("field name #{field.name} already in use", field.pos)
          end
          names_used.add(field.name)
        end
      end
    end
    check_dup_names.call(fields)

    check_enum_collision(enums)

    return fields, messages, enums, nested_type
  end

  def self.label(qualifier)
    case qualifier
    when :optional then :LABEL_OPTIONAL
    when :repeated then :LABEL_REPEATED
    when :required then :LABEL_REQUIRED
    when nil then :LABEL_OPTIONAL
    else
      raise NotImplementedError, qualifier.to_s
    end
  end

  def self.qualify(top_messages, sibling_messages, stack, name)
    case name
      # if the type is simple, we don't need to qualify it
    when "uint32", "bool", "double", "float", "int64", "uint64", "int32",
      "fixed64", "fixed32", "string", "bytes", "sfixed32", "sfixed64",
      "sint32", "sint64"
      ""
    else
      if name =~ /\./ # if the name has dots, we'll assume it's fully qualified
        "." + name
      else
        # If it's in a sibling, then use our current context
        if sibling_messages.find { |msg| msg.name == name }
          "." + (stack + [name]).join(".")
        else
          # If it's not a top level message, use the current context
          if !top_messages.find { |msg| msg.name == name }
            "." + (stack + [name]).join(".")
          else
            # Assume it's a top level type
            "." + name
          end
        end
      end
    end
  end

  def self.get_type(type, enums)
    if enums.any? { |e| e.name == type }
      :TYPE_ENUM
    else
      case type
      when "uint32" then :TYPE_UINT32
      when "bool" then :TYPE_BOOL
      when "double" then :TYPE_DOUBLE
      when "float" then :TYPE_FLOAT
      when "int64" then :TYPE_INT64
      when "uint64" then :TYPE_UINT64
      when "int32" then :TYPE_INT32
      when "fixed64" then :TYPE_FIXED64
      when "fixed32" then :TYPE_FIXED32
      when "string" then :TYPE_STRING
      when "bytes" then :TYPE_BYTES
      when "sfixed32" then :TYPE_SFIXED32
      when "sfixed64" then :TYPE_SFIXED64
      when "sint32" then :TYPE_SINT32
      when "sint64" then :TYPE_SINT64
      when MapType then :TYPE_MESSAGE
      else
        :TYPE_MESSAGE
      end
    end
  end

  # Parse a message definition
  def self.parse_message(input, pos, enums, top_messages, name_stack, is_proto3)
    input.eat_ws
    message_name = input.read_ident
    oneof_decls = []
    fields, messages, enums, nested_type = parse_body(input, pos, true, enums, top_messages, name_stack + [message_name], oneof_decls, is_proto3)

    # Add optional fields for proto3 optional fields
    fields.find_all { |field|
      field.label == :LABEL_OPTIONAL && field.proto3_optional
    }.each { |optional|
      optional.oneof_index = oneof_decls.length
      oneof_decls << AST::OneOfDescriptor.new("_" + optional.name)
    }
    Message.new(message_name, fields, messages, enums, oneof_decls, nested_type, nil, pos)
  end

  # Parse a oneof definition
  def self.parse_oneof(input, pos, enums, top_messages, name_stack, oneof_decls, is_proto3)
    input.eat_ws
    oneof_name = input.read_ident
    fields, _, _ = parse_body(input, pos, false, enums, top_messages, name_stack, oneof_decls, is_proto3)
    OneOf.new(oneof_name, fields, pos)
  end

  # Parse an enum definition
  def self.parse_enum(input, pos)
    constants = []
    options = {}
    reserved = []

    input.eat_ws
    enum_name = input.read_ident
    input.expect '{'

    until input.match '}'
      if input.match 'option'
        input.eat_ws
        option_name = input.read_ident
        input.expect '='
        value = parse_option_value(input)
        input.expect ';'
        options[option_name.to_sym] = value
        next
      end

      if input.match 'reserved'
        reserved.concat(parse_reserved(input))
        next
      end

      # Constant name and number
      input.eat_ws
      const_pos = input.pos
      name = input.read_ident
      input.expect '='
      input.eat_ws
      number = input.read_int
      _const_options = parse_field_options(input)
      input.expect ';'

      if name != name.upcase
        raise Parser::Error.new("enum constants should be uppercase identifiers", const_pos)
      end

      if constants.empty? && number != 0
        raise Parser::Error.new("the first enum constant should always have value 0", const_pos)
      end

      if number < -0x80_00_00_00 || number > 0x7F_FF_FF_FF
        raise Parser::Error.new("enum constants should be in int32 range", const_pos)
      end

      # Check for duplicate constant names
      names_taken = Set.new
      constants.each do |cst|
        if names_taken.include? cst.name
          raise Parser::Error.new("duplicate enum constant name #{cst.name}", cst.pos)
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
        raise Parser::Error.new("two constants use the number #{constant.number}", constant.pos)
      end
      numbers_taken.add(constant.number)
    end

    # Check that reserved constant numbers are not used
    constants.each do |constant|
      # For each reserved range
      reserved.each do |r|
        if (r.respond_to?(:include?) && r.include?(constant.number)) || r == constant.number
          raise Parser::Error.new("constant #{constant.name} uses reserved constant number #{constant.number}", constant.pos)
        end
      end
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
        raise Parser::Error.new("expected \"#{str}\"", pos)
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
    def eat_ws
      until eof?
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
              raise Parser::Error.new("end of input inside block comment", pos)
            end

            if match_exact("/*")
              raise Parser::Error.new("encountered '/*' inside block comment", pos)
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
      name = +''

      until eof?
        ch = peek_ch

        if !ch.match(/[A-Za-z0-9_]/)
          break
        end

        name << eat_ch
      end

      if name.empty?
        raise Parser::Error.new("expected identifier", pos)
      end

      return name
    end

    # Read a string constant, eg:
    # 'foobar'
    def read_string
      str = +''

      # The string must start with an opening quote
      expect '"'

      loop do
        if eof?
          raise Parser::Error.new("unexpected end of input inside string constant", pos)
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
            raise Parser::Error.new("unknown escape sequence in string constant", pos)
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
      until eof?
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
        raise Parser::Error.new("expected integer", pos)
      end

      sign * value
    end
  end
end
