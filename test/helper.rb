# frozen_string_literal: true

ENV["MT_NO_PLUGINS"] = "1"

require "minitest/autorun"
require "open3"
# require "minitest/color"
require_relative "fixtures/test_pb"
require "google/protobuf/descriptor_pb"
require "protoboeuf/codegen"

module ProtoBoeuf
  class Test < Minitest::Test
    DEFAULT_PROTOC_IMPORT_PATHS = [
      "/",
      *[
        "../lib/protoboeuf",
        "fixtures",
      ].map { |relative_path| File.expand_path(relative_path, __dir__) },
    ].freeze

    class << self
      def parse_proto_string(string, *additional_import_paths)
        Tempfile.create do |proto_file|
          proto_file.write(string)
          proto_file.flush

          protoc_parse(proto_file.path, additional_import_paths)
        end
      end

      def parse_proto_file(proto_path, *additional_import_paths)
        protoc_parse(proto_path, additional_import_paths)
      end

      private

      def protoc_parse(proto_path, additional_import_paths)
        all_import_paths = (DEFAULT_PROTOC_IMPORT_PATHS + additional_import_paths).uniq

        Tempfile.create do |binfile|
          cmd = [
            "protoc",
            "-o",
            binfile.path,
            all_import_paths.map { |path| ["-I", path] },
            File.expand_path(proto_path),
          ].flatten

          stdout, stderr, status = Open3.capture3(*cmd)

          raise <<~MSG.chomp unless status == 0
            protoc #{status}:
            ============
            Import Paths
            ============
              #{all_import_paths.join("\n  ")}

            ======
            STDOUT
            ======
            #{stdout}

            ======
            STDERR
            ======
            #{stderr}
          MSG

          binfile.rewind

          ::Google::Protobuf::FileDescriptorSet.decode(binfile.read)
        end
      end
    end

    def parse_proto_file(path, *additional_import_paths)
      self.class.parse_proto_file(path, *additional_import_paths)
    end

    def parse_proto_string(string, *additional_import_paths)
      self.class.parse_proto_string(string, *additional_import_paths)
    end
  end
end
