# frozen_string_literal: true

require "helper"

class GemTest < ProtoBoeuf::Test
  def test_can_be_required
    Tempfile.create do |file|
      file.write(<<~RUBY)
        require "bundler/inline"

        gemfile do
          gem "protoboeuf", path: "#{__dir__}/..", require: true
        end

        ::ProtoBoeuf

        require "protoboeuf/codegen"

        ::ProtoBoeuf::CodeGen

        exit 0
      RUBY

      file.flush

      assert(system(RbConfig.ruby, "-v", file.path), "Failed to require the gem")
    end
  end
end
