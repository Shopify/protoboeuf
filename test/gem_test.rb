# frozen_string_literal: true

require "helper"

class GemTest < ProtoBoeuf::Test
  def test_can_be_required
    assert_rb_runs_successfully(<<~RUBY, "Failed to require the gem")
      require "bundler/inline"

      gemfile do
        gem "protoboeuf", path: "#{__dir__}/..", require: true
      end

      ::ProtoBoeuf

      # The following should autoloaded
      ::ProtoBoeuf::CodeGen
      ::ProtoBoeuf::Google::Api::FieldBehavior
      ::ProtoBoeuf::Google::Protobuf::Any
      ::ProtoBoeuf::Google::Protobuf::FileDescriptorProto
      ::ProtoBoeuf::Google::Protobuf::FileDescriptorSet

      exit 0
    RUBY
  end

  def test_codegen_can_be_required
    # Test that we fixed a circular require bug: https://github.com/Shopify/protoboeuf/issues/173

    _, stderr, _ = assert_rb_runs_successfully(<<~RUBY)
      require "bundler/inline"

      gemfile do
        gem "protoboeuf", path: "#{__dir__}/..", require: false
      end

      require "protoboeuf"
      require "protoboeuf/codegen"

      exit 0
    RUBY

    refute_match(/warning: loading in progress, circular require considered harmful/, stderr)
  end

  private

  def assert_rb_runs_successfully(ruby, msg = "Ruby returned non-zero exit status")
    Tempfile.create do |file|
      file.write(ruby)
      file.flush

      stdout, stderr, status = Open3.capture3(RbConfig.ruby, "-v", file.path)

      assert_equal(0, status, msg)

      [stdout, stderr, status]
    end
  end
end
