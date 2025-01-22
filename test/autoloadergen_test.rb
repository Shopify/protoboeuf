# frozen_string_literal: true

require "helper"
require "protoboeuf/autoloadergen"

class AutoloaderGenTest < ProtoBoeuf::Test
  FIXTURE_PATH = File.expand_path("fixtures/autoloadergen/google", __dir__)

  def test_generates_autoloader_module
    # test/fixtures/autoloadergen/google/test_protos/*.proto needs an autoloader at
    # test/fixtures/autoloadergen/google/test_protos.rb
    autoloader_rb_path = File.expand_path("test_protos.rb", FIXTURE_PATH)

    autoloader_ruby = ProtoBoeuf::AutoloaderGen.new(autoloader_rb_path).to_ruby

    # If you ever want to regenerate the expected_autoloader_ruby, run:
    # File.binwrite(File.expand_path("test_protos.correct.rb", FIXTURE_PATH), autoloader_ruby)
    expected_autoloader_ruby = File.binread(File.expand_path("test_protos.correct.rb", FIXTURE_PATH))

    assert_equal(expected_autoloader_ruby, autoloader_ruby)
  end
end
