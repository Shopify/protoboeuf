# frozen_string_literal: true

require_relative "helper"
require "tmpdir"
require "google/protobuf/descriptor_pb"

module ProtoBoeuf
  class CodeGenCompatibilityTest < Test
    def test_to_proto
      ours, theirs = codegen_string('syntax = "proto3"; message ToProto { string s = 1; }')
      our_bin, their_bin = [ours, theirs].map { |m| m::ToProto.new(s: "s").to_proto }
      assert_equal(their_bin, our_bin)
    end

    def test_no_syntax
      ours, theirs = codegen_string("message NoSyntax { optional string s = 1; }")
      our_bin, their_bin = [ours, theirs].map { |m| m::NoSyntax.new(s: "s").to_proto }
      assert_equal(their_bin, our_bin)
    end

    def test_no_fields
      skip("FIXME: undefined local variable tag")

      ours, theirs = codegen_string("message NoFields { }")
      [ours, theirs].each do |m|
        klass = m::NoFields
        assert_kind_of(klass, klass.decode("\x08\x01"))
      end
    end

    def test_no_double
      skip("google decode raises parser error")
      ours, theirs = codegen_string('syntax = "proto3"; message NoDouble { optional double d = 1; }')
      our_msg, their_msg = [ours, theirs].map { |m| m::NoDouble.decode("\x09") }
      assert_equal(their_msg.d, our_msg.d)
    end

    def test_bounds
      ours, theirs = codegen_string(<<~EOPROTO)
        syntax = "proto3";
        message Bounds {
          uint64 uint64 = 1;
          sint64 sint64 = 2;
          sint32 sint32 = 3;
        }
      EOPROTO

      attr = {
        uint64: 1 << 63,
        sint64: -2**63,
        sint32: -2**31,
      }
      [ours, theirs].each do |m|
        obj = m::Bounds.decode(m::Bounds.new(**attr).to_proto)
        assert_equal(attr, obj.to_h)
      end
    end

    def test_unknown_fields
      our_m1, their_m1 = codegen_string(<<~EOPROTO)
        syntax = "proto3";
        message M1 {
          string a = 1;
          bool   b = 2;
          uint64 ui64 = 3;
          double i64 = 4;
          float i32 = 5;
          string s = 6;
        }
      EOPROTO
      our_msg, their_msg = [our_m1, their_m1].map do |m|
        m::M1.new(a: "A", b: true, ui64: 1234567890, i64: 2.5, i32: 1.25, s: "str").to_proto
      end
      assert_equal(their_msg, our_msg)

      msg = their_msg
      our_m2, their_m2 = codegen_string('syntax = "proto3"; message M2 { string a = 1; uint64 ui64 = 3; }')

      our_h, their_h = [our_m2, their_m2].map { |m| m::M2.decode(msg).to_h }
      assert_equal(their_h, our_h)

      our_msg, their_msg = [our_m2, their_m2].map { |m| m::M2.decode(msg).to_proto }
      assert_equal(their_msg, our_msg)
    end

    def test_syntax2
      skip("parser doesn't yet support proto2")
      ours, theirs = codegen_string('syntax = "proto2"; message ToProto { string s = 1; }')
      our_bin, their_bin = [ours, theirs].map { |m| m::ToProto.new(s: "s").to_proto }
      assert_equal(their_bin, our_bin)
    end

    def test_edition_2023
      skip("parser doesn't yet support editions")
      ours, theirs = codegen_string('edition = "2023"; message ToProto { string s = 1; }')
      our_bin, their_bin = [ours, theirs].map { |m| m::ToProto.new(s: "s").to_proto }
      assert_equal(their_bin, our_bin)
    end

    def test_decode
      # The "test/helper.rb" loads the generated ruby code from test.proto
      # so in order to load it again we need to nest it.
      ours, theirs = codegen_fixture("test.proto")

      # The constants in this generated module will be messages and enums.
      theirs::TestDecode.constants.each do |name|
        our_class, their_class = [ours, theirs].map { |m| m::TestDecode.const_get(name) }

        if !their_class.respond_to?(:decode) && their_class.respond_to?(:lookup)
          # Enum
          val = 0
          sym = their_class.lookup(val)

          assert_equal(sym, our_class.lookup(val), "enum #{name} lookup #{val}")
          assert_equal(their_class.resolve(sym), our_class.resolve(sym), "enum #{name} resolve #{sym.inspect}")
        else
          # Message
          our_msg, their_msg = [our_class, their_class].map { |c| c.decode("") }

          field_names(our_msg).each do |field|
            assert_field_equal(their_msg, our_msg, field, "msg #{name} field #{field.inspect}")
          end

          assert_equal(their_class.new.to_proto, our_class.new.to_proto, "to_proto")
        end
      end

      # Try out a sub message.
      str = theirs::TestDecode::SubmessageEncoder.new(
        value: theirs::TestDecode::SubmessageEncoder::Submessage.new,
      ).to_proto

      our_submsg, their_submsg = [ours, theirs].map { |m| m::TestDecode::SubmessageEncoder.decode(str) }

      [:strValue, :value].each do |field|
        assert_field_equal(their_submsg.value, our_submsg.value, field, "submessage.#{field}")
      end
    end

    private

    def field_names(msg)
      msg.methods.select { |m| m.to_s.match?(/^\w+=$/) }.map { |m| m.to_s.delete_suffix("=").to_sym }
    end

    def assert_field_equal(theirs, ours, field, message = nil)
      message ||= "expected #{field.inspect} to be equal"
      their_val, our_val = [theirs, ours].map { |x| x.public_send(field) }

      # Avoid passing nil to assert_equal.
      if their_val.nil?
        assert_nil(our_val, message)
      else
        begin
          assert_equal(their_val, our_val, message)
        rescue TypeError
          # Rather than "wrong argument type nil (expected Google::Protobuf::RepeatedField)"
          # show "expected not to be nil".
          refute_nil(our_val, "#{message} (expected #{their_val.inspect})")
          # If it wasn't nil raise the original error.
          raise
        end
      end
    end

    def find_test_name
      caller_locations.map(&:base_label).detect { |x| x.to_s.start_with?("test_") }
    end

    def codegen_file(file)
      # We need to change the package so that the messages aren't duplicated in Google's global namespace.
      str = File.read(file).sub(%r{^// package_placeholder$}, "package #{find_test_name};")
      codegen_string(str)
    end

    def codegen_fixture(name)
      (@codegen_fixture ||= {})[name] ||= codegen_file(File.expand_path("fixtures/#{name}", __dir__))
    end

    def codegen_string(string, name: find_test_name)
      @codegen_count = (@codegen_count || 0) + 1
      protoc_code = []
      unit = nil

      Dir.mktmpdir do |dir|
        file = File.join(dir, "#{name}#{@codegen_count}.proto")
        File.write(file, string)

        Dir.chdir(dir) do
          system("protoc", "-I#{dir}", "--ruby_out=.", file)
          Dir.glob("**/*.rb").each do |file|
            protoc_code << File.read(file)
          end
        end

        unit = ProtoBoeuf.parse_file(file)
      end

      boeuf_code = ProtoBoeuf::CodeGen.new(unit).to_ruby
      # puts protoc_code.flat_map(&:lines).map.with_index { |l, i| "#{i + 1}\t#{l}" }.join("")

      [
        Module.new { module_eval boeuf_code },
        Module.new { module_eval protoc_code.join("\n") },
      ]
    end
  end
end
