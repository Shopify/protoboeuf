# frozen_string_literal: true

module ProtoBoeuf
  class CodeGen
    # Responsible for determining which Ruby modules generated code should be nested under given the proto `package` and `ruby_package` options
    class ResolvedModules
      attr_reader :ruby_package_string, :file_package_string, :ruby_modules

      def initialize(file:)
        @file = file
        @ruby_package_string = file.options&.ruby_package
        @file_package_string = file.package || ""

        @overridden = @ruby_package_string && !@ruby_package_string.empty?

        @ruby_package_modules = @ruby_package_string.split("::")
        @file_package_modules = @file_package_string.split(".").filter_map do |m|
          m.split("_").map(&:capitalize).join unless m.empty?
        end
        @file_package_modules_string = @file_package_modules.join("::")
      end

      def ruby_modules
        overridden? @ruby_package_modules : @file_package_modules
      end

      def overridden?
        @overridden
      end

      def substitute(type_name)
        return type_name unless overridden?

        type_name.sub(/^#{file_package_string}::/, "#{ruby_package_string}::")
      end
    end
  end
end
