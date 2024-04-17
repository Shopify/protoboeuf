ENV["MT_NO_PLUGINS"] = "1"

require "minitest/autorun"
#require "minitest/color"
require_relative "fixtures/test_pb"
require "protoboeuf/parser"
require "protoboeuf/codegen"
require "protoboeuf/visitors"

module ProtoBoeuf
  class Test < Minitest::Test
  end
end
