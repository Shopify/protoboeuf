# frozen_string_literal: true

ENV["MT_NO_PLUGINS"] = "1"

require "minitest/autorun"
# require "minitest/color"
require_relative "fixtures/test_pb"
require "protoboeuf"

module ProtoBoeuf
  class Test < Minitest::Test
    extend ProtocUtils

    def parse_proto_file(...)
      self.class.parse_proto_file(...)
    end

    def parse_proto_string(...)
      self.class.parse_proto_string(...)
    end
  end
end
