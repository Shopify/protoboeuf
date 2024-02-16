require "helper"

module ProtoBuff
  class VisitorTest < Test
    def test_syntax
      proto = "syntax = \"proto3\";"
      unit = ProtoBuff.parse_string(proto)
      viz = Visitors::ToString.new
      assert_equal proto, viz.accept(unit)
    end
  end
end
