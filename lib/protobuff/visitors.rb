module ProtoBuff
  module Visitors
    class ToString
      def accept(node)
        node.accept self
      end

      def visit_unit(unit)
        p unit.package
      end
    end
  end
end
