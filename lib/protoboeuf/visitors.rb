# frozen_string_literal: true

module ProtoBoeuf
  module Visitors
    class ToString
      def initialize
        @indent = 0
      end

      def accept(node)
        node.accept(self)
      end

      def visit_file_descriptor_set(node)
        node.file.map { |n| n.accept(self) }.join
      end

      def visit_unit(unit)
        doc = "syntax = \"proto3\";"
        unless unit.imports.empty?
          doc += "\n\n"
          doc += unit.imports.map { |i| "import \"#{i}\";" }.join("\n")
        end

        if unit.package
          doc += "\n\n"
          doc += "package #{unit.package};"
        end

        unless unit.enum_type.empty?
          doc += "\n\n"
          doc += unit.enum_type.map { |msg| msg.accept(self) }.join("\n")
        end

        unless unit.message_type.empty?
          doc += "\n\n"
          doc += unit.message_type.map { |msg| msg.accept(self) }.join("\n")
        end
        doc
      end

      def visit_message(msg)
        @indent += 1

        oneof_fields = []

        msg.field.each do |field|
          if field.has_oneof_index? && !field.proto3_optional
            (oneof_fields[field.oneof_index] ||= []) << field
          end
        end

        body = "".dup
        body += msg.enum_type.map { |f| f.accept(self) }.join("\n")
        body += "\n" unless msg.enum_type.empty?
        body += msg.messages.map { |f| f.accept(self) }.join("\n")
        body += "\n" unless msg.messages.empty?

        oneof_decls = msg.oneof_decl.each_with_index.select do |_oneof, idx|
          oneof_fields[idx]
        end
        body += oneof_decls.map do |oneof, idx|
          next unless oneof_fields[idx]

          visit_oneof(oneof, oneof_fields[idx])
        end.join("\n")
        body += "\n" unless oneof_decls.empty?

        body += msg.field.reject do |f|
          f.oneof_index && oneof_fields[f.oneof_index]
        end.map { |f| f.accept(self) }.join("\n")
        body += "\n" unless msg.field.empty?

        body += msg.nested_type.map { |f| visit_message(f) }.join("\n")
        body += "\n" unless msg.nested_type.empty?

        @indent -= 1

        indent("message #{msg.name} {\n") + body + indent("}")
      end

      def visit_field(field)
        options = if !field.options
          ""
        else
          " [" + field.options.to_h.reject { |_, v| v.nil? }.map { |k, v| "#{k} = #{v}" }.join(", ") + "]"
        end
        indent([qualifier(field), type(field), field.name].compact.join(" ") + " = " + "#{field.number}#{options};")
      end

      def visit_enum(enum)
        @indent += 1
        body = enum.value.map { |f| f.accept(self) }.join("\n")
        body += "\n" unless enum.value.empty?
        @indent -= 1
        indent("enum #{enum.name} {\n") + body + indent("}")
      end

      def visit_constant(const)
        indent("#{const.name} = #{const.number};")
      end

      def visit_oneof(oneof, children)
        @indent += 1
        body = children.map { |f| f.accept(self) }.join("\n")
        body += "\n" unless children.empty?
        @indent -= 1

        indent("oneof #{oneof.name} {\n") + body + indent("}")
      end

      private

      def qualifier(field)
        if field.proto3_optional
          "optional"
        else
          case field.label
          when :LABEL_REQUIRED then "required"
          when :LABEL_REPEATED then "repeated"
          else # rubocop:disable Style/EmptyElse
            nil
          end
        end
      end

      def indent(str)
        ("  " * @indent) + str
      end

      def type(field)
        if field.type == :TYPE_MESSAGE
          field.type_name.delete_prefix(".")
        elsif field.type == :TYPE_ENUM
          field.type_name.split(".").last
        else
          field.type.to_s.sub(/^TYPE_/, "").downcase
        end
      end
    end
  end
end
