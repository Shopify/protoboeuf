# frozen_string_literal: true

require "open3"
require "tempfile"

require "google/protobuf/descriptor_pb"

module ProtoBoeuf
  module ProtocUtils
    DEFAULT_PROTOC_IMPORT_PATHS = [
      "/",
      __dir__,
    ].freeze

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
      all_import_paths = (DEFAULT_PROTOC_IMPORT_PATHS + [File.dirname(proto_path)] + additional_import_paths).uniq

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
end
