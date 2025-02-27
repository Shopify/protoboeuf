# frozen_string_literal: true

require "helper"
require "protoboeuf/codegen"

module ProtoBoeuf
  class CodeGen
    class ResolvedModulesTest < ProtoBoeuf::Test
      def test_overriden?
        no_override = parse_proto_string(<<~PROTO)
          syntax = "proto3";

          package foo;

          message Foo {}
        PROTO

        refute_predicate ResolvedModules.new(file: no_override.file.first), :overridden?

        with_override = parse_proto_string(<<~PROTO)
          syntax = "proto3";

          package foo;

          option ruby_package = "My::Package";

          message Foo {}
        PROTO

        assert_predicate ResolvedModules.new(file: with_override.file.first), :overridden?
      end

      def test_file_package_string
        no_package = parse_proto_string(<<~PROTO)
          message Foo {}
        PROTO

        assert_equal("", ResolvedModules.new(file: no_package.file.first).file_package_string)

        with_package = parse_proto_string(<<~PROTO)
          package foo.bar;

          message Foo {}
        PROTO

        assert_equal("foo.bar", ResolvedModules.new(file: with_package.file.first).file_package_string)

        with_ruby_package = parse_proto_string(<<~PROTO)
          package foo.bar;

          option ruby_package = "My::Package";

          message Foo {}
        PROTO

        assert_equal("foo.bar", ResolvedModules.new(file: with_ruby_package.file.first).file_package_string)
      end

      def test_ruby_package_string
        no_package = parse_proto_string(<<~PROTO)
          message Foo {}
        PROTO

        assert_nil(ResolvedModules.new(file: no_package.file.first).ruby_package_string)

        with_package = parse_proto_string(<<~PROTO)
          package foo.bar;

          message Foo {}
        PROTO

        assert_nil(ResolvedModules.new(file: with_package.file.first).ruby_package_string)

        with_ruby_package = parse_proto_string(<<~PROTO)
          package foo.bar;

          option ruby_package = "My::Package";

          message Foo {}
        PROTO

        assert_equal("My::Package", ResolvedModules.new(file: with_ruby_package.file.first).ruby_package_string)
      end

      def test_ruby_modules
        no_package = parse_proto_string(<<~PROTO)
          message Foo {}
        PROTO

        assert_equal([], ResolvedModules.new(file: no_package.file.first).ruby_modules)

        with_package = parse_proto_string(<<~PROTO)
          package foo.bar;

          message Foo {}
        PROTO

        assert_equal(%w[Foo Bar], ResolvedModules.new(file: with_package.file.first).ruby_modules)

        with_ruby_package = parse_proto_string(<<~PROTO)
          package foo.bar;

          option ruby_package = "My::Package";

          message Foo {}
        PROTO

        assert_equal(%w[My Package], ResolvedModules.new(file: with_ruby_package.file.first).ruby_modules)
      end

      def test_substitute
        no_package = parse_proto_string(<<~PROTO)
          message Foo {}
        PROTO

        assert_equal("Foo", ResolvedModules.new(file: no_package.file.first).substitute("Foo"))

        with_package = parse_proto_string(<<~PROTO)
          package foo.bar;

          message Foo {}
        PROTO

        assert_equal("Foo", ResolvedModules.new(file: with_package.file.first).substitute("Foo"))
        assert_equal(".foo.bar.Foo", ResolvedModules.new(file: with_package.file.first).substitute(".foo.bar.Foo"))

        with_ruby_package = parse_proto_string(<<~PROTO)
          package foo.bar;

          option ruby_package = "My::Package";

          message Foo {}
        PROTO

        assert_equal("Foo", ResolvedModules.new(file: with_package.file.first).substitute("Foo"))
        assert_equal("My::Package::Foo", ResolvedModules.new(file: with_ruby_package.file.first).substitute(".foo.bar.Foo"))
      end
    end
  end
end
