# frozen_string_literal: true

require "helper"

class SigStoreTest < ProtoBoeuf::Test
  def test_sigstore
    Dir.entries("test/fixtures/sigstore").each do |entry|
      next unless entry.include?(".proto")

      file_name = File.join("test/fixtures/sigstore", entry)
      # puts file_name

      unit = ProtoBoeuf.parse_file(file_name)
      gen = ProtoBoeuf::CodeGen.new(unit)

      gen.to_ruby
    end
  end
end
