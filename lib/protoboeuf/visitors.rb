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

        oneof_fields = []

        msg.field.each do |field|
          if field.has_oneof_index? && !field.proto3_optional
            (oneof_fields[field.oneof_index] ||= []) << field
          end
        end

        body = "".dup
        body += msg.enum_type.map { |f| f.accept self }.join("\n")
        body += "\n" if msg.enum_type.length > 0
        body += msg.messages.map { |f| f.accept self }.join("\n")
        body += "\n" if msg.messages.length > 0

        oneof_decls = msg.oneof_decl.each_with_index.select { |oneof, idx|
          oneof_fields[idx]
        }
        body += oneof_decls.map { |oneof, idx|
          next unless oneof_fields[idx]
          visit_oneof oneof, oneof_fields[idx]
        }.join("\n")
        body += "\n" if oneof_decls.length > 0

        body += msg.field.reject { |f|
          f.oneof_index && oneof_fields[f.oneof_index]
        }.map { |f| f.accept self }.join("\n")
        body += "\n" if msg.field.length > 0

        body += msg.nested_type.map { |f| visit_message f }.join("\n")
        body += "\n" if msg.nested_type.length > 0

        @indent -= 1

        indent("message #{msg.name} {\n") + body + indent("}")
      end

      def visit_field(field)
        options = if !field.options
          ""
        else
          " [" + field.options.to_h.reject { |_, v| v.nil? }.map { |k,v| "#{k} = #{v}" }.join(", ") + "]"
        end
        indent([qualifier(field), type(field), field.name].compact.join(" ") + " = " + "#{field.number}#{options};")
      end

      def visit_enum(enum)
        @indent += 1
        body = enum.value.map { |f| f.accept self }.join("\n")
        body += "\n" if enum.value.length > 0
        @indent -= 1
        indent("enum #{enum.name} {\n") + body + indent("}")
      end

      def visit_constant(const)
        indent("#{const.name} = #{const.number};")
      end

      def visit_oneof(oneof, children)
        @indent += 1
        body = children.map { |f| f.accept self }.join("\n")
        body += "\n" if children.length > 0
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
          else
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
          field.type_name.delete_prefix(".")
        else
          field.type.to_s.sub(/^TYPE_/, '').downcase
        end
        #case field.type
      end
    end
  end
end
