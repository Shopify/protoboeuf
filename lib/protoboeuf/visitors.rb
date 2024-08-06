# frozen_string_literal: true

module ProtoBoeuf
  module Visitors
    class ToString
      def initialize
        @indent = 0
      end

      def accept(node)
        node.accept self
      end

      def visit_file_descriptor_set(node)
        node.file.map { |n| n.accept self }.join
      end

      def visit_unit(unit)
        doc = "syntax = \"proto3\";"
        if unit.imports.length > 0
          doc += "\n\n"
          doc += unit.imports.map { |i| "import \"#{i}\";" }.join("\n")
        end

        if unit.package
          doc += "\n\n"
          doc += "package #{unit.package};"
        end

        if unit.enum_type.length > 0
          doc += "\n\n"
          doc += unit.enum_type.map { |msg| msg.accept self }.join("\n")
        end

        if unit.message_type.length > 0
          doc += "\n\n"
          doc += unit.message_type.map { |msg| msg.accept self }.join("\n")
        end
        doc
      end

      def visit_message(msg)
        @indent += 1
        body = "".dup
        body += msg.enum_type.map { |f| f.accept self }.join("\n")
        body += "\n" if msg.enum_type.length > 0
        body += msg.messages.map { |f| f.accept self }.join("\n")
        body += "\n" if msg.messages.length > 0
        body += msg.field.map { |f| f.accept self }.join("\n")
        body += "\n" if msg.field.length > 0
        @indent -= 1

        indent("message #{msg.name} {\n") + body + indent("}")
      end

      def visit_field(field)
        options = if field.options.empty?
          ""
        else
          " [" + field.options.map { |k,v| "#{k} = #{v}" }.join(", ") + "]"
        end
        indent([field.qualifier, field.type, field.name].compact.join(" ") + " = " + "#{field.number}#{options};")
      end

      def visit_enum(enum)
        @indent += 1
        body = enum.constants.map { |f| f.accept self }.join("\n")
        body += "\n" if enum.constants.length > 0
        @indent -= 1
        indent("enum #{enum.name} {\n") + body + indent("}")
      end

      def visit_constant(const)
        indent("#{const.name} = #{const.number};")
      end

      def visit_oneof(oneof)
        @indent += 1
        body = oneof.fields.map { |f| f.accept self }.join("\n")
        body += "\n" if oneof.fields.length > 0
        @indent -= 1

        indent("oneof #{oneof.name} {\n") + body + indent("}")
      end

      private

      def indent(str)
        ("  " * @indent) + str
      end
    end
  end
end
