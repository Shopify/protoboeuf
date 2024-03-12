require "helper"

module ProtoBoeuf
  class VisitorTest < Test
    def test_syntax
      proto = "syntax = \"proto3\";"
      unit = ProtoBoeuf.parse_string(proto)
      viz = Visitors::ToString.new
      assert_equal proto, viz.accept(unit)
    end

    def test_imports
      proto = (<<-eoproto).strip
syntax = "proto3";

import "google/protobuf/wrappers.proto";
import "google/protobuf/metafield.proto";
      eoproto
      unit = ProtoBoeuf.parse_string(proto)
      viz = Visitors::ToString.new
      assert_equal proto, viz.accept(unit)
    end

    def test_package
      proto = (<<-eoproto).strip
syntax = "proto3";

package protoboeuf.protoboeuf;
      eoproto
      unit = ProtoBoeuf.parse_string(proto)
      viz = Visitors::ToString.new
      assert_equal proto, viz.accept(unit)
    end

    def test_empty_message
      proto = (<<-eoproto).strip
syntax = "proto3";

message Aaron {
}
      eoproto
      unit = ProtoBoeuf.parse_string(proto)
      viz = Visitors::ToString.new
      assert_equal proto, viz.accept(unit)
    end

    def test_non_empty_message
      proto = (<<-eoproto).strip
syntax = "proto3";

message Aaron {
  optional uint64 age = 1;
  required bool friends = 2;
  repeated string friend_list = 3;
  optional google.protobuf.StringValue name = 4;
  uint32 number_of_cats = 5;
}
      eoproto
      unit = ProtoBoeuf.parse_string(proto)
      viz = Visitors::ToString.new
      assert_equal proto, viz.accept(unit)
    end

    def test_enum
      proto = (<<-eoproto).strip
syntax = "proto3";

enum Cool {
  A = 0;
  B = 1;
}

message Aaron {
  required Cool field = 1;
}
      eoproto
      unit = ProtoBoeuf.parse_string(proto)
      viz = Visitors::ToString.new
      assert_equal proto, viz.accept(unit)
    end

    def test_oneof
      proto = (<<-eoproto).strip
syntax = "proto3";

message Aaron {
  oneof thing {
    uint64 id = 1;
  }
}
      eoproto
      unit = ProtoBoeuf.parse_string(proto)
      viz = Visitors::ToString.new
      assert_equal proto, viz.accept(unit)
    end

    def test_nested_message
      proto = (<<-eoproto).strip
syntax = "proto3";

message Aaron {
  message Cat {
    oneof hi {
      uint64 index = 1;
      uint64 index2 = 2;
    }
    optional uint64 age = 3;
  }
}
      eoproto
      unit = ProtoBoeuf.parse_string(proto)
      viz = Visitors::ToString.new
      assert_equal proto, viz.accept(unit)
    end

    def test_nested_enums
      proto = (<<-eoproto).strip
syntax = "proto3";

message Aaron {
  enum Hello {
    A = 0;
    B = 1;
  }
  required Hello hi = 1;
}
      eoproto
      unit = ProtoBoeuf.parse_string(proto)
      viz = Visitors::ToString.new
      assert_equal proto, viz.accept(unit)
    end

    def test_deprecated_fields
      proto = (<<-eoproto).strip
syntax = "proto3";

message Aaron {
  int32 old_field = 6 [deprecated = true];
}
      eoproto
      unit = ProtoBoeuf.parse_string(proto)
      viz = Visitors::ToString.new
      assert_equal proto, viz.accept(unit)
    end
  end
end
