# encoding: ascii-8bit
# frozen_string_literal: true

module ProtoBoeuf
  module Protobuf
    module Edition
      EDITION_UNKNOWN = 0
      EDITION_LEGACY = 900
      EDITION_PROTO2 = 998
      EDITION_PROTO3 = 999
      EDITION_2023 = 1000
      EDITION_2024 = 1001
      EDITION_1_TEST_ONLY = 1
      EDITION_2_TEST_ONLY = 2
      EDITION_99997_TEST_ONLY = 99_997
      EDITION_99998_TEST_ONLY = 99_998
      EDITION_99999_TEST_ONLY = 99_999
      EDITION_MAX = 2_147_483_647

      def self.lookup(val)
        if val == 0
          :EDITION_UNKNOWN
        elsif val == 900
          :EDITION_LEGACY
        elsif val == 998
          :EDITION_PROTO2
        elsif val == 999
          :EDITION_PROTO3
        elsif val == 1000
          :EDITION_2023
        elsif val == 1001
          :EDITION_2024
        elsif val == 1
          :EDITION_1_TEST_ONLY
        elsif val == 2
          :EDITION_2_TEST_ONLY
        elsif val == 99_997
          :EDITION_99997_TEST_ONLY
        elsif val == 99_998
          :EDITION_99998_TEST_ONLY
        elsif val == 99_999
          :EDITION_99999_TEST_ONLY
        elsif val == 2_147_483_647
          :EDITION_MAX
        end
      end

      def self.resolve(val)
        if val == :EDITION_UNKNOWN
          0
        elsif val == :EDITION_LEGACY
          900
        elsif val == :EDITION_PROTO2
          998
        elsif val == :EDITION_PROTO3
          999
        elsif val == :EDITION_2023
          1000
        elsif val == :EDITION_2024
          1001
        elsif val == :EDITION_1_TEST_ONLY
          1
        elsif val == :EDITION_2_TEST_ONLY
          2
        elsif val == :EDITION_99997_TEST_ONLY
          99_997
        elsif val == :EDITION_99998_TEST_ONLY
          99_998
        elsif val == :EDITION_99999_TEST_ONLY
          99_999
        elsif val == :EDITION_MAX
          2_147_483_647
        end
      end
    end

    class FileDescriptorSet
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      attr_reader :file

      def file=(v)
        @file = v
      end

      def initialize(file: [])
        @file = file
      end

      def decode_from(buff, index, len)
        @file = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## DECODE REPEATED
            list = @file
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::FileDescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0xa
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        list = @file
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x0a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["file".to_sym] = @file
        result
      end
    end
    class FileDescriptorProto
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      attr_reader :dependency

      attr_reader :public_dependency

      attr_reader :weak_dependency

      attr_reader :message_type

      attr_reader :enum_type

      attr_reader :service

      attr_reader :extension

      # enum readers
      def edition
        ProtoBoeuf::Protobuf::Edition.lookup(@edition) || @edition
      end
      # optional field readers

      attr_reader :name

      attr_reader :package

      attr_reader :options

      attr_reader :source_code_info

      attr_reader :syntax

      def dependency=(v)
        @dependency = v
      end

      def public_dependency=(v)
        v.each do |v|
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}}) for field public_dependency is out of bounds (-2147483648..2147483647)"
          end
        end

        @public_dependency = v
      end

      def weak_dependency=(v)
        v.each do |v|
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}}) for field weak_dependency is out of bounds (-2147483648..2147483647)"
          end
        end

        @weak_dependency = v
      end

      def message_type=(v)
        @message_type = v
      end

      def enum_type=(v)
        @enum_type = v
      end

      def service=(v)
        @service = v
      end

      def extension=(v)
        @extension = v
      end

      # enum writers
      def edition=(v)
        @edition = ProtoBoeuf::Protobuf::Edition.resolve(v) || v
      end

      # BEGIN writers for optional fields

      def name=(v)
        @_bitmask |= 0x0000000000000001
        @name = v
      end

      def package=(v)
        @_bitmask |= 0x0000000000000002
        @package = v
      end

      def options=(v)
        @_bitmask |= 0x0000000000000004
        @options = v
      end

      def source_code_info=(v)
        @_bitmask |= 0x0000000000000008
        @source_code_info = v
      end

      def syntax=(v)
        @_bitmask |= 0x0000000000000010
        @syntax = v
      end
      # END writers for optional fields

      def initialize(
        name: "",
        package: "",
        dependency: [],
        public_dependency: [],
        weak_dependency: [],
        message_type: [],
        enum_type: [],
        service: [],
        extension: [],
        options: nil,
        source_code_info: nil,
        syntax: "",
        edition: 0
      )
        @_bitmask = 0

        @name = name

        @package = package

        @dependency = dependency

        public_dependency.each do |v|
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}}) for field public_dependency is out of bounds (-2147483648..2147483647)"
          end
        end
        @public_dependency = public_dependency

        weak_dependency.each do |v|
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}}) for field weak_dependency is out of bounds (-2147483648..2147483647)"
          end
        end
        @weak_dependency = weak_dependency

        @message_type = message_type

        @enum_type = enum_type

        @service = service

        @extension = extension

        @options = options

        @source_code_info = source_code_info

        @syntax = syntax

        @edition = ProtoBoeuf::Protobuf::Edition.resolve(edition) || edition
      end

      def has_name?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_package?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def has_options?
        (@_bitmask & 0x0000000000000004) == 0x0000000000000004
      end

      def has_source_code_info?
        (@_bitmask & 0x0000000000000008) == 0x0000000000000008
      end

      def has_syntax?
        (@_bitmask & 0x0000000000000010) == 0x0000000000000010
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @name = ""
        @package = ""
        @dependency = []
        @public_dependency = []
        @weak_dependency = []
        @message_type = []
        @enum_type = []
        @service = []
        @extension = []
        @options = nil
        @source_code_info = nil
        @syntax = ""
        @edition = 0

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @name = buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x12
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @package =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x1a
            ## DECODE REPEATED
            list = @dependency
            while true
              ## PULL_STRING
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              list << buff.byteslice(index, value).force_encoding(
                Encoding::UTF_8
              )
              index += value

              ## END PULL_STRING

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x1a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x52
            ## PULL_UINT64
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            goal = index + value
            list = @public_dependency
            while true
              break if index >= goal
              ## PULL_INT32
              list << if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

              ## END PULL_INT32
            end

            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x5a
            ## PULL_UINT64
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            goal = index + value
            list = @weak_dependency
            while true
              break if index >= goal
              ## PULL_INT32
              list << if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

              ## END PULL_INT32
            end

            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x22
            ## DECODE REPEATED
            list = @message_type
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::DescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x22
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x2a
            ## DECODE REPEATED
            list = @enum_type
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::EnumDescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x2a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x32
            ## DECODE REPEATED
            list = @service
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::ServiceDescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x32
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x3a
            ## DECODE REPEATED
            list = @extension
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::FieldDescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x3a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x42
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @options =
              ProtoBoeuf::Protobuf::FileOptions.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x4a
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @source_code_info =
              ProtoBoeuf::Protobuf::SourceCodeInfo.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000008
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x62
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @syntax =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000010
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x70
            ## PULL_INT64
            @edition =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000020
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @name
        if ((len = val.bytesize) > 0)
          buff << 0x0a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @package
        if ((len = val.bytesize) > 0)
          buff << 0x12
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        list = @dependency
        if list.size > 0
          list.each do |item|
            val = item
            if ((len = val.bytesize) > 0)
              buff << 0x1a
              while len != 0
                byte = len & 0x7F
                len >>= 7
                byte |= 0x80 if len > 0
                buff << byte
              end

              buff << (val.ascii_only? ? val : val.b)
            end
          end
        end

        list = @public_dependency
        if list.size > 0
          buff << 0x52

          # Save the buffer size before appending the repeated bytes
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"

          # write each item
          list.each do |item|
            val = item
            if val != 0
              while val != 0
                byte = val & 0x7F

                val >>= 7
                # This drops the top bits,
                # Otherwise, with a signed right shift,
                # we get infinity one bits at the top
                val &= (1 << 57) - 1

                byte |= 0x80 if val != 0
                buff << byte
              end
            end
          end

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end
        end

        list = @weak_dependency
        if list.size > 0
          buff << 0x5a

          # Save the buffer size before appending the repeated bytes
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"

          # write each item
          list.each do |item|
            val = item
            if val != 0
              while val != 0
                byte = val & 0x7F

                val >>= 7
                # This drops the top bits,
                # Otherwise, with a signed right shift,
                # we get infinity one bits at the top
                val &= (1 << 57) - 1

                byte |= 0x80 if val != 0
                buff << byte
              end
            end
          end

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end
        end

        list = @message_type
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x22

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        list = @enum_type
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x2a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        list = @service
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x32

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        list = @extension
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x3a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        val = @options
        if val
          buff << 0x42

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        val = @source_code_info
        if val
          buff << 0x4a

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        val = @syntax
        if ((len = val.bytesize) > 0)
          buff << 0x62
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @edition
        if val != 0
          buff << 0x70

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        buff
      end

      def to_h
        result = {}
        result["name".to_sym] = @name
        result["package".to_sym] = @package
        result["dependency".to_sym] = @dependency
        result["public_dependency".to_sym] = @public_dependency
        result["weak_dependency".to_sym] = @weak_dependency
        result["message_type".to_sym] = @message_type
        result["enum_type".to_sym] = @enum_type
        result["service".to_sym] = @service
        result["extension".to_sym] = @extension
        result["options".to_sym] = @options.to_h
        result["source_code_info".to_sym] = @source_code_info.to_h
        result["syntax".to_sym] = @syntax
        result["edition".to_sym] = @edition
        result
      end
    end
    class DescriptorProto
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      class ExtensionRange
        def self.decode(buff)
          allocate.decode_from(buff.b, 0, buff.bytesize)
        end

        def self.encode(obj)
          obj._encode("".b)
        end
        # required field readers

        # optional field readers

        attr_reader :start

        attr_reader :end

        attr_reader :options

        # BEGIN writers for optional fields

        def start=(v)
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}) for field start is out of bounds (-2147483648..2147483647)"
          end

          @_bitmask |= 0x0000000000000001
          @start = v
        end

        def end=(v)
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}) for field end is out of bounds (-2147483648..2147483647)"
          end

          @_bitmask |= 0x0000000000000002
          @end = v
        end

        def options=(v)
          @_bitmask |= 0x0000000000000004
          @options = v
        end
        # END writers for optional fields

        def initialize(start: 0, end: 0, options: nil)
          @_bitmask = 0

          unless -2_147_483_648 <= start && start <= 2_147_483_647
            raise RangeError,
                  "Value (#{start}) for field start is out of bounds (-2147483648..2147483647)"
          end
          @start = start

          unless -2_147_483_648 <= binding.local_variable_get(:end) &&
                   binding.local_variable_get(:end) <= 2_147_483_647
            raise RangeError,
                  "Value (#{binding.local_variable_get(:end)}) for field end is out of bounds (-2147483648..2147483647)"
          end
          @end = binding.local_variable_get(:end)

          @options = options
        end

        def has_start?
          (@_bitmask & 0x0000000000000001) == 0x0000000000000001
        end

        def has_end?
          (@_bitmask & 0x0000000000000002) == 0x0000000000000002
        end

        def has_options?
          (@_bitmask & 0x0000000000000004) == 0x0000000000000004
        end

        def decode_from(buff, index, len)
          @_bitmask = 0

          @start = 0
          @end = 0
          @options = nil

          tag = buff.getbyte(index)
          index += 1

          while true
            if tag == 0x8
              ## PULL_INT32
              @start =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT32

              @_bitmask |= 0x0000000000000001
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x10
              ## PULL_INT32
              @end =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT32

              @_bitmask |= 0x0000000000000002
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x1a
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              @options =
                ProtoBoeuf::Protobuf::ExtensionRangeOptions.allocate.decode_from(
                  buff,
                  index,
                  index += msg_len
                )
              ## END PULL_MESSAGE

              @_bitmask |= 0x0000000000000004
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end

            return self if index >= len
          end
        end
        def _encode(buff)
          val = @start
          if val != 0
            buff << 0x08

            while val != 0
              byte = val & 0x7F

              val >>= 7
              # This drops the top bits,
              # Otherwise, with a signed right shift,
              # we get infinity one bits at the top
              val &= (1 << 57) - 1

              byte |= 0x80 if val != 0
              buff << byte
            end
          end

          val = @end
          if val != 0
            buff << 0x10

            while val != 0
              byte = val & 0x7F

              val >>= 7
              # This drops the top bits,
              # Otherwise, with a signed right shift,
              # we get infinity one bits at the top
              val &= (1 << 57) - 1

              byte |= 0x80 if val != 0
              buff << byte
            end
          end

          val = @options
          if val
            buff << 0x1a

            # Save the buffer size before appending the submessage
            current_len = buff.bytesize

            # Write a single dummy byte to later store encoded length
            buff << 42 # "*"
            val._encode(buff)

            # Calculate the submessage's size
            submessage_size = buff.bytesize - current_len - 1

            # Hope the size fits in one byte
            byte = submessage_size & 0x7F
            submessage_size >>= 7
            byte |= 0x80 if submessage_size > 0
            buff.setbyte(current_len, byte)

            # If the sub message was bigger
            if submessage_size > 0
              current_len += 1

              # compute how much we need to shift
              encoded_int_len = 0
              remaining_size = submessage_size
              while remaining_size != 0
                remaining_size >>= 7
                encoded_int_len += 1
              end

              # Make space in the string with dummy bytes
              buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

              # Overwrite the dummy bytes with the encoded length
              while submessage_size != 0
                byte = submessage_size & 0x7F
                submessage_size >>= 7
                byte |= 0x80 if submessage_size > 0
                buff.setbyte(current_len, byte)
                current_len += 1
              end
            end

            buff
          end

          buff
        end

        def to_h
          result = {}
          result["start".to_sym] = @start
          result["end".to_sym] = @end
          result["options".to_sym] = @options.to_h
          result
        end
      end

      class ReservedRange
        def self.decode(buff)
          allocate.decode_from(buff.b, 0, buff.bytesize)
        end

        def self.encode(obj)
          obj._encode("".b)
        end
        # required field readers

        # optional field readers

        attr_reader :start

        attr_reader :end

        # BEGIN writers for optional fields

        def start=(v)
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}) for field start is out of bounds (-2147483648..2147483647)"
          end

          @_bitmask |= 0x0000000000000001
          @start = v
        end

        def end=(v)
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}) for field end is out of bounds (-2147483648..2147483647)"
          end

          @_bitmask |= 0x0000000000000002
          @end = v
        end
        # END writers for optional fields

        def initialize(start: 0, end: 0)
          @_bitmask = 0

          unless -2_147_483_648 <= start && start <= 2_147_483_647
            raise RangeError,
                  "Value (#{start}) for field start is out of bounds (-2147483648..2147483647)"
          end
          @start = start

          unless -2_147_483_648 <= binding.local_variable_get(:end) &&
                   binding.local_variable_get(:end) <= 2_147_483_647
            raise RangeError,
                  "Value (#{binding.local_variable_get(:end)}) for field end is out of bounds (-2147483648..2147483647)"
          end
          @end = binding.local_variable_get(:end)
        end

        def has_start?
          (@_bitmask & 0x0000000000000001) == 0x0000000000000001
        end

        def has_end?
          (@_bitmask & 0x0000000000000002) == 0x0000000000000002
        end

        def decode_from(buff, index, len)
          @_bitmask = 0

          @start = 0
          @end = 0

          tag = buff.getbyte(index)
          index += 1

          while true
            if tag == 0x8
              ## PULL_INT32
              @start =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT32

              @_bitmask |= 0x0000000000000001
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x10
              ## PULL_INT32
              @end =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT32

              @_bitmask |= 0x0000000000000002
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end

            return self if index >= len
          end
        end
        def _encode(buff)
          val = @start
          if val != 0
            buff << 0x08

            while val != 0
              byte = val & 0x7F

              val >>= 7
              # This drops the top bits,
              # Otherwise, with a signed right shift,
              # we get infinity one bits at the top
              val &= (1 << 57) - 1

              byte |= 0x80 if val != 0
              buff << byte
            end
          end

          val = @end
          if val != 0
            buff << 0x10

            while val != 0
              byte = val & 0x7F

              val >>= 7
              # This drops the top bits,
              # Otherwise, with a signed right shift,
              # we get infinity one bits at the top
              val &= (1 << 57) - 1

              byte |= 0x80 if val != 0
              buff << byte
            end
          end

          buff
        end

        def to_h
          result = {}
          result["start".to_sym] = @start
          result["end".to_sym] = @end
          result
        end
      end
      # required field readers

      attr_reader :field

      attr_reader :extension

      attr_reader :nested_type

      attr_reader :enum_type

      attr_reader :extension_range

      attr_reader :oneof_decl

      attr_reader :reserved_range

      attr_reader :reserved_name

      # optional field readers

      attr_reader :name

      attr_reader :options

      def field=(v)
        @field = v
      end

      def extension=(v)
        @extension = v
      end

      def nested_type=(v)
        @nested_type = v
      end

      def enum_type=(v)
        @enum_type = v
      end

      def extension_range=(v)
        @extension_range = v
      end

      def oneof_decl=(v)
        @oneof_decl = v
      end

      def reserved_range=(v)
        @reserved_range = v
      end

      def reserved_name=(v)
        @reserved_name = v
      end

      # BEGIN writers for optional fields

      def name=(v)
        @_bitmask |= 0x0000000000000001
        @name = v
      end

      def options=(v)
        @_bitmask |= 0x0000000000000002
        @options = v
      end
      # END writers for optional fields

      def initialize(
        name: "",
        field: [],
        extension: [],
        nested_type: [],
        enum_type: [],
        extension_range: [],
        oneof_decl: [],
        options: nil,
        reserved_range: [],
        reserved_name: []
      )
        @_bitmask = 0

        @name = name

        @field = field

        @extension = extension

        @nested_type = nested_type

        @enum_type = enum_type

        @extension_range = extension_range

        @oneof_decl = oneof_decl

        @options = options

        @reserved_range = reserved_range

        @reserved_name = reserved_name
      end

      def has_name?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_options?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @name = ""
        @field = []
        @extension = []
        @nested_type = []
        @enum_type = []
        @extension_range = []
        @oneof_decl = []
        @options = nil
        @reserved_range = []
        @reserved_name = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @name = buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x12
            ## DECODE REPEATED
            list = @field
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::FieldDescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x12
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x32
            ## DECODE REPEATED
            list = @extension
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::FieldDescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x32
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x1a
            ## DECODE REPEATED
            list = @nested_type
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::DescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x1a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x22
            ## DECODE REPEATED
            list = @enum_type
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::EnumDescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x22
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x2a
            ## DECODE REPEATED
            list = @extension_range
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::DescriptorProto::ExtensionRange.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x2a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x42
            ## DECODE REPEATED
            list = @oneof_decl
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::OneofDescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x42
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x3a
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @options =
              ProtoBoeuf::Protobuf::MessageOptions.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x4a
            ## DECODE REPEATED
            list = @reserved_range
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::DescriptorProto::ReservedRange.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x4a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x52
            ## DECODE REPEATED
            list = @reserved_name
            while true
              ## PULL_STRING
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              list << buff.byteslice(index, value).force_encoding(
                Encoding::UTF_8
              )
              index += value

              ## END PULL_STRING

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x52
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @name
        if ((len = val.bytesize) > 0)
          buff << 0x0a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        list = @field
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x12

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        list = @extension
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x32

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        list = @nested_type
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x1a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        list = @enum_type
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x22

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        list = @extension_range
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x2a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        list = @oneof_decl
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x42

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        val = @options
        if val
          buff << 0x3a

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        list = @reserved_range
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x4a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        list = @reserved_name
        if list.size > 0
          list.each do |item|
            val = item
            if ((len = val.bytesize) > 0)
              buff << 0x52
              while len != 0
                byte = len & 0x7F
                len >>= 7
                byte |= 0x80 if len > 0
                buff << byte
              end

              buff << (val.ascii_only? ? val : val.b)
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["name".to_sym] = @name
        result["field".to_sym] = @field
        result["extension".to_sym] = @extension
        result["nested_type".to_sym] = @nested_type
        result["enum_type".to_sym] = @enum_type
        result["extension_range".to_sym] = @extension_range
        result["oneof_decl".to_sym] = @oneof_decl
        result["options".to_sym] = @options.to_h
        result["reserved_range".to_sym] = @reserved_range
        result["reserved_name".to_sym] = @reserved_name
        result
      end
    end
    class ExtensionRangeOptions
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      class Declaration
        def self.decode(buff)
          allocate.decode_from(buff.b, 0, buff.bytesize)
        end

        def self.encode(obj)
          obj._encode("".b)
        end
        # required field readers

        # optional field readers

        attr_reader :number

        attr_reader :full_name

        attr_reader :type

        attr_reader :reserved

        attr_reader :repeated

        # BEGIN writers for optional fields

        def number=(v)
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}) for field number is out of bounds (-2147483648..2147483647)"
          end

          @_bitmask |= 0x0000000000000001
          @number = v
        end

        def full_name=(v)
          @_bitmask |= 0x0000000000000002
          @full_name = v
        end

        def type=(v)
          @_bitmask |= 0x0000000000000004
          @type = v
        end

        def reserved=(v)
          @_bitmask |= 0x0000000000000008
          @reserved = v
        end

        def repeated=(v)
          @_bitmask |= 0x0000000000000010
          @repeated = v
        end
        # END writers for optional fields

        def initialize(
          number: 0,
          full_name: "",
          type: "",
          reserved: false,
          repeated: false
        )
          @_bitmask = 0

          unless -2_147_483_648 <= number && number <= 2_147_483_647
            raise RangeError,
                  "Value (#{number}) for field number is out of bounds (-2147483648..2147483647)"
          end
          @number = number

          @full_name = full_name

          @type = type

          @reserved = reserved

          @repeated = repeated
        end

        def has_number?
          (@_bitmask & 0x0000000000000001) == 0x0000000000000001
        end

        def has_full_name?
          (@_bitmask & 0x0000000000000002) == 0x0000000000000002
        end

        def has_type?
          (@_bitmask & 0x0000000000000004) == 0x0000000000000004
        end

        def has_reserved?
          (@_bitmask & 0x0000000000000008) == 0x0000000000000008
        end

        def has_repeated?
          (@_bitmask & 0x0000000000000010) == 0x0000000000000010
        end

        def decode_from(buff, index, len)
          @_bitmask = 0

          @number = 0
          @full_name = ""
          @type = ""
          @reserved = false
          @repeated = false

          tag = buff.getbyte(index)
          index += 1

          while true
            if tag == 0x8
              ## PULL_INT32
              @number =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT32

              @_bitmask |= 0x0000000000000001
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x12
              ## PULL_STRING
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              @full_name =
                buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
              index += value

              ## END PULL_STRING

              @_bitmask |= 0x0000000000000002
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x1a
              ## PULL_STRING
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              @type =
                buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
              index += value

              ## END PULL_STRING

              @_bitmask |= 0x0000000000000004
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x28
              ## PULL BOOLEAN
              @reserved = (buff.getbyte(index) == 1)
              index += 1
              ## END PULL BOOLEAN

              @_bitmask |= 0x0000000000000008
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x30
              ## PULL BOOLEAN
              @repeated = (buff.getbyte(index) == 1)
              index += 1
              ## END PULL BOOLEAN

              @_bitmask |= 0x0000000000000010
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end

            return self if index >= len
          end
        end
        def _encode(buff)
          val = @number
          if val != 0
            buff << 0x08

            while val != 0
              byte = val & 0x7F

              val >>= 7
              # This drops the top bits,
              # Otherwise, with a signed right shift,
              # we get infinity one bits at the top
              val &= (1 << 57) - 1

              byte |= 0x80 if val != 0
              buff << byte
            end
          end

          val = @full_name
          if ((len = val.bytesize) > 0)
            buff << 0x12
            while len != 0
              byte = len & 0x7F
              len >>= 7
              byte |= 0x80 if len > 0
              buff << byte
            end

            buff << (val.ascii_only? ? val : val.b)
          end

          val = @type
          if ((len = val.bytesize) > 0)
            buff << 0x1a
            while len != 0
              byte = len & 0x7F
              len >>= 7
              byte |= 0x80 if len > 0
              buff << byte
            end

            buff << (val.ascii_only? ? val : val.b)
          end

          val = @reserved
          if val == true
            buff << 0x28

            buff << 1
          elsif val == false
            # Default value, encode nothing
          else
            raise "bool values should be true or false"
          end

          val = @repeated
          if val == true
            buff << 0x30

            buff << 1
          elsif val == false
            # Default value, encode nothing
          else
            raise "bool values should be true or false"
          end

          buff
        end

        def to_h
          result = {}
          result["number".to_sym] = @number
          result["full_name".to_sym] = @full_name
          result["type".to_sym] = @type
          result["reserved".to_sym] = @reserved
          result["repeated".to_sym] = @repeated
          result
        end
      end
      module VerificationState
        DECLARATION = 0
        UNVERIFIED = 1

        def self.lookup(val)
          if val == 0
            :DECLARATION
          elsif val == 1
            :UNVERIFIED
          end
        end

        def self.resolve(val)
          if val == :DECLARATION
            0
          elsif val == :UNVERIFIED
            1
          end
        end
      end
      # required field readers

      attr_reader :uninterpreted_option

      attr_reader :declaration

      # enum readers
      def verification
        ProtoBoeuf::Protobuf::ExtensionRangeOptions::VerificationState.lookup(
          @verification
        ) || @verification
      end
      # optional field readers

      attr_reader :features

      def uninterpreted_option=(v)
        @uninterpreted_option = v
      end

      def declaration=(v)
        @declaration = v
      end

      # enum writers
      def verification=(v)
        @verification =
          ProtoBoeuf::Protobuf::ExtensionRangeOptions::VerificationState.resolve(
            v
          ) || v
      end

      # BEGIN writers for optional fields

      def features=(v)
        @_bitmask |= 0x0000000000000001
        @features = v
      end
      # END writers for optional fields

      def initialize(
        uninterpreted_option: [],
        declaration: [],
        features: nil,
        verification: 0
      )
        @_bitmask = 0

        @uninterpreted_option = uninterpreted_option

        @declaration = declaration

        @features = features

        @verification =
          ProtoBoeuf::Protobuf::ExtensionRangeOptions::VerificationState.resolve(
            verification
          ) || verification
      end

      def has_features?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @uninterpreted_option = []
        @declaration = []
        @features = nil
        @verification = 0

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0x1f3a
            ## DECODE REPEATED
            list = @uninterpreted_option
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::UninterpretedOption.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x1f3a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x12
            ## DECODE REPEATED
            list = @declaration
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::ExtensionRangeOptions::Declaration.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x12
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x192
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @features =
              ProtoBoeuf::Protobuf::FeatureSet.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x18
            ## PULL_INT64
            @verification =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        list = @uninterpreted_option
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x1f3a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        list = @declaration
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x12

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        val = @features
        if val
          buff << 0x192

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        val = @verification
        if val != 0
          buff << 0x18

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        buff
      end

      def to_h
        result = {}
        result["uninterpreted_option".to_sym] = @uninterpreted_option
        result["declaration".to_sym] = @declaration
        result["features".to_sym] = @features.to_h
        result["verification".to_sym] = @verification
        result
      end
    end
    class FieldDescriptorProto
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      module Type
        TYPE_DOUBLE = 1
        TYPE_FLOAT = 2
        TYPE_INT64 = 3
        TYPE_UINT64 = 4
        TYPE_INT32 = 5
        TYPE_FIXED64 = 6
        TYPE_FIXED32 = 7
        TYPE_BOOL = 8
        TYPE_STRING = 9
        TYPE_GROUP = 10
        TYPE_MESSAGE = 11
        TYPE_BYTES = 12
        TYPE_UINT32 = 13
        TYPE_ENUM = 14
        TYPE_SFIXED32 = 15
        TYPE_SFIXED64 = 16
        TYPE_SINT32 = 17
        TYPE_SINT64 = 18

        def self.lookup(val)
          if val == 1
            :TYPE_DOUBLE
          elsif val == 2
            :TYPE_FLOAT
          elsif val == 3
            :TYPE_INT64
          elsif val == 4
            :TYPE_UINT64
          elsif val == 5
            :TYPE_INT32
          elsif val == 6
            :TYPE_FIXED64
          elsif val == 7
            :TYPE_FIXED32
          elsif val == 8
            :TYPE_BOOL
          elsif val == 9
            :TYPE_STRING
          elsif val == 10
            :TYPE_GROUP
          elsif val == 11
            :TYPE_MESSAGE
          elsif val == 12
            :TYPE_BYTES
          elsif val == 13
            :TYPE_UINT32
          elsif val == 14
            :TYPE_ENUM
          elsif val == 15
            :TYPE_SFIXED32
          elsif val == 16
            :TYPE_SFIXED64
          elsif val == 17
            :TYPE_SINT32
          elsif val == 18
            :TYPE_SINT64
          end
        end

        def self.resolve(val)
          if val == :TYPE_DOUBLE
            1
          elsif val == :TYPE_FLOAT
            2
          elsif val == :TYPE_INT64
            3
          elsif val == :TYPE_UINT64
            4
          elsif val == :TYPE_INT32
            5
          elsif val == :TYPE_FIXED64
            6
          elsif val == :TYPE_FIXED32
            7
          elsif val == :TYPE_BOOL
            8
          elsif val == :TYPE_STRING
            9
          elsif val == :TYPE_GROUP
            10
          elsif val == :TYPE_MESSAGE
            11
          elsif val == :TYPE_BYTES
            12
          elsif val == :TYPE_UINT32
            13
          elsif val == :TYPE_ENUM
            14
          elsif val == :TYPE_SFIXED32
            15
          elsif val == :TYPE_SFIXED64
            16
          elsif val == :TYPE_SINT32
            17
          elsif val == :TYPE_SINT64
            18
          end
        end
      end

      module Label
        LABEL_OPTIONAL = 1
        LABEL_REPEATED = 3
        LABEL_REQUIRED = 2

        def self.lookup(val)
          if val == 1
            :LABEL_OPTIONAL
          elsif val == 3
            :LABEL_REPEATED
          elsif val == 2
            :LABEL_REQUIRED
          end
        end

        def self.resolve(val)
          if val == :LABEL_OPTIONAL
            1
          elsif val == :LABEL_REPEATED
            3
          elsif val == :LABEL_REQUIRED
            2
          end
        end
      end
      # required field readers

      # enum readers
      def label
        ProtoBoeuf::Protobuf::FieldDescriptorProto::Label.lookup(@label) ||
          @label
      end
      def type
        ProtoBoeuf::Protobuf::FieldDescriptorProto::Type.lookup(@type) || @type
      end
      # optional field readers

      attr_reader :name

      attr_reader :number

      attr_reader :type_name

      attr_reader :extendee

      attr_reader :default_value

      attr_reader :oneof_index

      attr_reader :json_name

      attr_reader :options

      attr_reader :proto3_optional

      # enum writers
      def label=(v)
        @label =
          ProtoBoeuf::Protobuf::FieldDescriptorProto::Label.resolve(v) || v
      end
      def type=(v)
        @type = ProtoBoeuf::Protobuf::FieldDescriptorProto::Type.resolve(v) || v
      end

      # BEGIN writers for optional fields

      def name=(v)
        @_bitmask |= 0x0000000000000001
        @name = v
      end

      def number=(v)
        unless -2_147_483_648 <= v && v <= 2_147_483_647
          raise RangeError,
                "Value (#{v}) for field number is out of bounds (-2147483648..2147483647)"
        end

        @_bitmask |= 0x0000000000000002
        @number = v
      end

      def type_name=(v)
        @_bitmask |= 0x0000000000000010
        @type_name = v
      end

      def extendee=(v)
        @_bitmask |= 0x0000000000000020
        @extendee = v
      end

      def default_value=(v)
        @_bitmask |= 0x0000000000000040
        @default_value = v
      end

      def oneof_index=(v)
        unless -2_147_483_648 <= v && v <= 2_147_483_647
          raise RangeError,
                "Value (#{v}) for field oneof_index is out of bounds (-2147483648..2147483647)"
        end

        @_bitmask |= 0x0000000000000080
        @oneof_index = v
      end

      def json_name=(v)
        @_bitmask |= 0x0000000000000100
        @json_name = v
      end

      def options=(v)
        @_bitmask |= 0x0000000000000200
        @options = v
      end

      def proto3_optional=(v)
        @_bitmask |= 0x0000000000000400
        @proto3_optional = v
      end
      # END writers for optional fields

      def initialize(
        name: "",
        number: 0,
        label: 0,
        type: 0,
        type_name: "",
        extendee: "",
        default_value: "",
        oneof_index: 0,
        json_name: "",
        options: nil,
        proto3_optional: false
      )
        @_bitmask = 0

        @name = name

        unless -2_147_483_648 <= number && number <= 2_147_483_647
          raise RangeError,
                "Value (#{number}) for field number is out of bounds (-2147483648..2147483647)"
        end
        @number = number

        @label =
          ProtoBoeuf::Protobuf::FieldDescriptorProto::Label.resolve(label) ||
            label
        @type =
          ProtoBoeuf::Protobuf::FieldDescriptorProto::Type.resolve(type) || type

        @type_name = type_name

        @extendee = extendee

        @default_value = default_value

        unless -2_147_483_648 <= oneof_index && oneof_index <= 2_147_483_647
          raise RangeError,
                "Value (#{oneof_index}) for field oneof_index is out of bounds (-2147483648..2147483647)"
        end
        @oneof_index = oneof_index

        @json_name = json_name

        @options = options

        @proto3_optional = proto3_optional
      end

      def has_name?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_number?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def has_type_name?
        (@_bitmask & 0x0000000000000010) == 0x0000000000000010
      end

      def has_extendee?
        (@_bitmask & 0x0000000000000020) == 0x0000000000000020
      end

      def has_default_value?
        (@_bitmask & 0x0000000000000040) == 0x0000000000000040
      end

      def has_oneof_index?
        (@_bitmask & 0x0000000000000080) == 0x0000000000000080
      end

      def has_json_name?
        (@_bitmask & 0x0000000000000100) == 0x0000000000000100
      end

      def has_options?
        (@_bitmask & 0x0000000000000200) == 0x0000000000000200
      end

      def has_proto3_optional?
        (@_bitmask & 0x0000000000000400) == 0x0000000000000400
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @name = ""
        @number = 0
        @label = 0
        @type = 0
        @type_name = ""
        @extendee = ""
        @default_value = ""
        @oneof_index = 0
        @json_name = ""
        @options = nil
        @proto3_optional = false

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @name = buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x18
            ## PULL_INT32
            @number =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT32

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x20
            ## PULL_INT64
            @label =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x28
            ## PULL_INT64
            @type =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000008
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x32
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @type_name =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000010
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x12
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @extendee =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000020
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x3a
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @default_value =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000040
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x48
            ## PULL_INT32
            @oneof_index =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT32

            @_bitmask |= 0x0000000000000080
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x52
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @json_name =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000100
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x42
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @options =
              ProtoBoeuf::Protobuf::FieldOptions.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000200
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x88
            ## PULL BOOLEAN
            @proto3_optional = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000400
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @name
        if ((len = val.bytesize) > 0)
          buff << 0x0a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @number
        if val != 0
          buff << 0x18

          while val != 0
            byte = val & 0x7F

            val >>= 7
            # This drops the top bits,
            # Otherwise, with a signed right shift,
            # we get infinity one bits at the top
            val &= (1 << 57) - 1

            byte |= 0x80 if val != 0
            buff << byte
          end
        end

        val = @label
        if val != 0
          buff << 0x20

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @type
        if val != 0
          buff << 0x28

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @type_name
        if ((len = val.bytesize) > 0)
          buff << 0x32
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @extendee
        if ((len = val.bytesize) > 0)
          buff << 0x12
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @default_value
        if ((len = val.bytesize) > 0)
          buff << 0x3a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @oneof_index
        if val != 0
          buff << 0x48

          while val != 0
            byte = val & 0x7F

            val >>= 7
            # This drops the top bits,
            # Otherwise, with a signed right shift,
            # we get infinity one bits at the top
            val &= (1 << 57) - 1

            byte |= 0x80 if val != 0
            buff << byte
          end
        end

        val = @json_name
        if ((len = val.bytesize) > 0)
          buff << 0x52
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @options
        if val
          buff << 0x42

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        val = @proto3_optional
        if val == true
          buff << 0x88

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        buff
      end

      def to_h
        result = {}
        result["name".to_sym] = @name
        result["number".to_sym] = @number
        result["label".to_sym] = @label
        result["type".to_sym] = @type
        result["type_name".to_sym] = @type_name
        result["extendee".to_sym] = @extendee
        result["default_value".to_sym] = @default_value
        result["oneof_index".to_sym] = @oneof_index
        result["json_name".to_sym] = @json_name
        result["options".to_sym] = @options.to_h
        result["proto3_optional".to_sym] = @proto3_optional
        result
      end
    end
    class OneofDescriptorProto
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      # optional field readers

      attr_reader :name

      attr_reader :options

      # BEGIN writers for optional fields

      def name=(v)
        @_bitmask |= 0x0000000000000001
        @name = v
      end

      def options=(v)
        @_bitmask |= 0x0000000000000002
        @options = v
      end
      # END writers for optional fields

      def initialize(name: "", options: nil)
        @_bitmask = 0

        @name = name

        @options = options
      end

      def has_name?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_options?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @name = ""
        @options = nil

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @name = buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x12
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @options =
              ProtoBoeuf::Protobuf::OneofOptions.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @name
        if ((len = val.bytesize) > 0)
          buff << 0x0a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @options
        if val
          buff << 0x12

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        buff
      end

      def to_h
        result = {}
        result["name".to_sym] = @name
        result["options".to_sym] = @options.to_h
        result
      end
    end
    class EnumDescriptorProto
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      class EnumReservedRange
        def self.decode(buff)
          allocate.decode_from(buff.b, 0, buff.bytesize)
        end

        def self.encode(obj)
          obj._encode("".b)
        end
        # required field readers

        # optional field readers

        attr_reader :start

        attr_reader :end

        # BEGIN writers for optional fields

        def start=(v)
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}) for field start is out of bounds (-2147483648..2147483647)"
          end

          @_bitmask |= 0x0000000000000001
          @start = v
        end

        def end=(v)
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}) for field end is out of bounds (-2147483648..2147483647)"
          end

          @_bitmask |= 0x0000000000000002
          @end = v
        end
        # END writers for optional fields

        def initialize(start: 0, end: 0)
          @_bitmask = 0

          unless -2_147_483_648 <= start && start <= 2_147_483_647
            raise RangeError,
                  "Value (#{start}) for field start is out of bounds (-2147483648..2147483647)"
          end
          @start = start

          unless -2_147_483_648 <= binding.local_variable_get(:end) &&
                   binding.local_variable_get(:end) <= 2_147_483_647
            raise RangeError,
                  "Value (#{binding.local_variable_get(:end)}) for field end is out of bounds (-2147483648..2147483647)"
          end
          @end = binding.local_variable_get(:end)
        end

        def has_start?
          (@_bitmask & 0x0000000000000001) == 0x0000000000000001
        end

        def has_end?
          (@_bitmask & 0x0000000000000002) == 0x0000000000000002
        end

        def decode_from(buff, index, len)
          @_bitmask = 0

          @start = 0
          @end = 0

          tag = buff.getbyte(index)
          index += 1

          while true
            if tag == 0x8
              ## PULL_INT32
              @start =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT32

              @_bitmask |= 0x0000000000000001
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x10
              ## PULL_INT32
              @end =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT32

              @_bitmask |= 0x0000000000000002
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end

            return self if index >= len
          end
        end
        def _encode(buff)
          val = @start
          if val != 0
            buff << 0x08

            while val != 0
              byte = val & 0x7F

              val >>= 7
              # This drops the top bits,
              # Otherwise, with a signed right shift,
              # we get infinity one bits at the top
              val &= (1 << 57) - 1

              byte |= 0x80 if val != 0
              buff << byte
            end
          end

          val = @end
          if val != 0
            buff << 0x10

            while val != 0
              byte = val & 0x7F

              val >>= 7
              # This drops the top bits,
              # Otherwise, with a signed right shift,
              # we get infinity one bits at the top
              val &= (1 << 57) - 1

              byte |= 0x80 if val != 0
              buff << byte
            end
          end

          buff
        end

        def to_h
          result = {}
          result["start".to_sym] = @start
          result["end".to_sym] = @end
          result
        end
      end
      # required field readers

      attr_reader :value

      attr_reader :reserved_range

      attr_reader :reserved_name

      # optional field readers

      attr_reader :name

      attr_reader :options

      def value=(v)
        @value = v
      end

      def reserved_range=(v)
        @reserved_range = v
      end

      def reserved_name=(v)
        @reserved_name = v
      end

      # BEGIN writers for optional fields

      def name=(v)
        @_bitmask |= 0x0000000000000001
        @name = v
      end

      def options=(v)
        @_bitmask |= 0x0000000000000002
        @options = v
      end
      # END writers for optional fields

      def initialize(
        name: "",
        value: [],
        options: nil,
        reserved_range: [],
        reserved_name: []
      )
        @_bitmask = 0

        @name = name

        @value = value

        @options = options

        @reserved_range = reserved_range

        @reserved_name = reserved_name
      end

      def has_name?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_options?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @name = ""
        @value = []
        @options = nil
        @reserved_range = []
        @reserved_name = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @name = buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x12
            ## DECODE REPEATED
            list = @value
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::EnumValueDescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x12
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x1a
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @options =
              ProtoBoeuf::Protobuf::EnumOptions.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x22
            ## DECODE REPEATED
            list = @reserved_range
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::EnumDescriptorProto::EnumReservedRange.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x22
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x2a
            ## DECODE REPEATED
            list = @reserved_name
            while true
              ## PULL_STRING
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              list << buff.byteslice(index, value).force_encoding(
                Encoding::UTF_8
              )
              index += value

              ## END PULL_STRING

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x2a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @name
        if ((len = val.bytesize) > 0)
          buff << 0x0a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        list = @value
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x12

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        val = @options
        if val
          buff << 0x1a

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        list = @reserved_range
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x22

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        list = @reserved_name
        if list.size > 0
          list.each do |item|
            val = item
            if ((len = val.bytesize) > 0)
              buff << 0x2a
              while len != 0
                byte = len & 0x7F
                len >>= 7
                byte |= 0x80 if len > 0
                buff << byte
              end

              buff << (val.ascii_only? ? val : val.b)
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["name".to_sym] = @name
        result["value".to_sym] = @value
        result["options".to_sym] = @options.to_h
        result["reserved_range".to_sym] = @reserved_range
        result["reserved_name".to_sym] = @reserved_name
        result
      end
    end
    class EnumValueDescriptorProto
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      # optional field readers

      attr_reader :name

      attr_reader :number

      attr_reader :options

      # BEGIN writers for optional fields

      def name=(v)
        @_bitmask |= 0x0000000000000001
        @name = v
      end

      def number=(v)
        unless -2_147_483_648 <= v && v <= 2_147_483_647
          raise RangeError,
                "Value (#{v}) for field number is out of bounds (-2147483648..2147483647)"
        end

        @_bitmask |= 0x0000000000000002
        @number = v
      end

      def options=(v)
        @_bitmask |= 0x0000000000000004
        @options = v
      end
      # END writers for optional fields

      def initialize(name: "", number: 0, options: nil)
        @_bitmask = 0

        @name = name

        unless -2_147_483_648 <= number && number <= 2_147_483_647
          raise RangeError,
                "Value (#{number}) for field number is out of bounds (-2147483648..2147483647)"
        end
        @number = number

        @options = options
      end

      def has_name?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_number?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def has_options?
        (@_bitmask & 0x0000000000000004) == 0x0000000000000004
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @name = ""
        @number = 0
        @options = nil

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @name = buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x10
            ## PULL_INT32
            @number =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT32

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x1a
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @options =
              ProtoBoeuf::Protobuf::EnumValueOptions.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @name
        if ((len = val.bytesize) > 0)
          buff << 0x0a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @number
        if val != 0
          buff << 0x10

          while val != 0
            byte = val & 0x7F

            val >>= 7
            # This drops the top bits,
            # Otherwise, with a signed right shift,
            # we get infinity one bits at the top
            val &= (1 << 57) - 1

            byte |= 0x80 if val != 0
            buff << byte
          end
        end

        val = @options
        if val
          buff << 0x1a

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        buff
      end

      def to_h
        result = {}
        result["name".to_sym] = @name
        result["number".to_sym] = @number
        result["options".to_sym] = @options.to_h
        result
      end
    end
    class ServiceDescriptorProto
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      attr_reader :method

      # optional field readers

      attr_reader :name

      attr_reader :options

      def method=(v)
        @method = v
      end

      # BEGIN writers for optional fields

      def name=(v)
        @_bitmask |= 0x0000000000000001
        @name = v
      end

      def options=(v)
        @_bitmask |= 0x0000000000000002
        @options = v
      end
      # END writers for optional fields

      def initialize(name: "", method: [], options: nil)
        @_bitmask = 0

        @name = name

        @method = method

        @options = options
      end

      def has_name?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_options?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @name = ""
        @method = []
        @options = nil

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @name = buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x12
            ## DECODE REPEATED
            list = @method
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::MethodDescriptorProto.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x12
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x1a
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @options =
              ProtoBoeuf::Protobuf::ServiceOptions.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @name
        if ((len = val.bytesize) > 0)
          buff << 0x0a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        list = @method
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x12

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        val = @options
        if val
          buff << 0x1a

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        buff
      end

      def to_h
        result = {}
        result["name".to_sym] = @name
        result["method".to_sym] = @method
        result["options".to_sym] = @options.to_h
        result
      end
    end
    class MethodDescriptorProto
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      # optional field readers

      attr_reader :name

      attr_reader :input_type

      attr_reader :output_type

      attr_reader :options

      attr_reader :client_streaming

      attr_reader :server_streaming

      # BEGIN writers for optional fields

      def name=(v)
        @_bitmask |= 0x0000000000000001
        @name = v
      end

      def input_type=(v)
        @_bitmask |= 0x0000000000000002
        @input_type = v
      end

      def output_type=(v)
        @_bitmask |= 0x0000000000000004
        @output_type = v
      end

      def options=(v)
        @_bitmask |= 0x0000000000000008
        @options = v
      end

      def client_streaming=(v)
        @_bitmask |= 0x0000000000000010
        @client_streaming = v
      end

      def server_streaming=(v)
        @_bitmask |= 0x0000000000000020
        @server_streaming = v
      end
      # END writers for optional fields

      def initialize(
        name: "",
        input_type: "",
        output_type: "",
        options: nil,
        client_streaming: false,
        server_streaming: false
      )
        @_bitmask = 0

        @name = name

        @input_type = input_type

        @output_type = output_type

        @options = options

        @client_streaming = client_streaming

        @server_streaming = server_streaming
      end

      def has_name?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_input_type?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def has_output_type?
        (@_bitmask & 0x0000000000000004) == 0x0000000000000004
      end

      def has_options?
        (@_bitmask & 0x0000000000000008) == 0x0000000000000008
      end

      def has_client_streaming?
        (@_bitmask & 0x0000000000000010) == 0x0000000000000010
      end

      def has_server_streaming?
        (@_bitmask & 0x0000000000000020) == 0x0000000000000020
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @name = ""
        @input_type = ""
        @output_type = ""
        @options = nil
        @client_streaming = false
        @server_streaming = false

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @name = buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x12
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @input_type =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x1a
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @output_type =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x22
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @options =
              ProtoBoeuf::Protobuf::MethodOptions.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000008
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x28
            ## PULL BOOLEAN
            @client_streaming = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000010
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x30
            ## PULL BOOLEAN
            @server_streaming = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000020
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @name
        if ((len = val.bytesize) > 0)
          buff << 0x0a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @input_type
        if ((len = val.bytesize) > 0)
          buff << 0x12
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @output_type
        if ((len = val.bytesize) > 0)
          buff << 0x1a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @options
        if val
          buff << 0x22

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        val = @client_streaming
        if val == true
          buff << 0x28

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @server_streaming
        if val == true
          buff << 0x30

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        buff
      end

      def to_h
        result = {}
        result["name".to_sym] = @name
        result["input_type".to_sym] = @input_type
        result["output_type".to_sym] = @output_type
        result["options".to_sym] = @options.to_h
        result["client_streaming".to_sym] = @client_streaming
        result["server_streaming".to_sym] = @server_streaming
        result
      end
    end
    class FileOptions
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      module OptimizeMode
        SPEED = 1
        CODE_SIZE = 2
        LITE_RUNTIME = 3

        def self.lookup(val)
          if val == 1
            :SPEED
          elsif val == 2
            :CODE_SIZE
          elsif val == 3
            :LITE_RUNTIME
          end
        end

        def self.resolve(val)
          if val == :SPEED
            1
          elsif val == :CODE_SIZE
            2
          elsif val == :LITE_RUNTIME
            3
          end
        end
      end
      # required field readers

      attr_reader :uninterpreted_option

      # enum readers
      def optimize_for
        ProtoBoeuf::Protobuf::FileOptions::OptimizeMode.lookup(@optimize_for) ||
          @optimize_for
      end
      # optional field readers

      attr_reader :java_package

      attr_reader :java_outer_classname

      attr_reader :java_multiple_files

      attr_reader :java_generate_equals_and_hash

      attr_reader :java_string_check_utf8

      attr_reader :go_package

      attr_reader :cc_generic_services

      attr_reader :java_generic_services

      attr_reader :py_generic_services

      attr_reader :deprecated

      attr_reader :cc_enable_arenas

      attr_reader :objc_class_prefix

      attr_reader :csharp_namespace

      attr_reader :swift_prefix

      attr_reader :php_class_prefix

      attr_reader :php_namespace

      attr_reader :php_metadata_namespace

      attr_reader :ruby_package

      attr_reader :features

      def uninterpreted_option=(v)
        @uninterpreted_option = v
      end

      # enum writers
      def optimize_for=(v)
        @optimize_for =
          ProtoBoeuf::Protobuf::FileOptions::OptimizeMode.resolve(v) || v
      end

      # BEGIN writers for optional fields

      def java_package=(v)
        @_bitmask |= 0x0000000000000001
        @java_package = v
      end

      def java_outer_classname=(v)
        @_bitmask |= 0x0000000000000002
        @java_outer_classname = v
      end

      def java_multiple_files=(v)
        @_bitmask |= 0x0000000000000004
        @java_multiple_files = v
      end

      def java_generate_equals_and_hash=(v)
        @_bitmask |= 0x0000000000000008
        @java_generate_equals_and_hash = v
      end

      def java_string_check_utf8=(v)
        @_bitmask |= 0x0000000000000010
        @java_string_check_utf8 = v
      end

      def go_package=(v)
        @_bitmask |= 0x0000000000000040
        @go_package = v
      end

      def cc_generic_services=(v)
        @_bitmask |= 0x0000000000000080
        @cc_generic_services = v
      end

      def java_generic_services=(v)
        @_bitmask |= 0x0000000000000100
        @java_generic_services = v
      end

      def py_generic_services=(v)
        @_bitmask |= 0x0000000000000200
        @py_generic_services = v
      end

      def deprecated=(v)
        @_bitmask |= 0x0000000000000400
        @deprecated = v
      end

      def cc_enable_arenas=(v)
        @_bitmask |= 0x0000000000000800
        @cc_enable_arenas = v
      end

      def objc_class_prefix=(v)
        @_bitmask |= 0x0000000000001000
        @objc_class_prefix = v
      end

      def csharp_namespace=(v)
        @_bitmask |= 0x0000000000002000
        @csharp_namespace = v
      end

      def swift_prefix=(v)
        @_bitmask |= 0x0000000000004000
        @swift_prefix = v
      end

      def php_class_prefix=(v)
        @_bitmask |= 0x0000000000008000
        @php_class_prefix = v
      end

      def php_namespace=(v)
        @_bitmask |= 0x0000000000010000
        @php_namespace = v
      end

      def php_metadata_namespace=(v)
        @_bitmask |= 0x0000000000020000
        @php_metadata_namespace = v
      end

      def ruby_package=(v)
        @_bitmask |= 0x0000000000040000
        @ruby_package = v
      end

      def features=(v)
        @_bitmask |= 0x0000000000080000
        @features = v
      end
      # END writers for optional fields

      def initialize(
        java_package: "",
        java_outer_classname: "",
        java_multiple_files: false,
        java_generate_equals_and_hash: false,
        java_string_check_utf8: false,
        optimize_for: 0,
        go_package: "",
        cc_generic_services: false,
        java_generic_services: false,
        py_generic_services: false,
        deprecated: false,
        cc_enable_arenas: false,
        objc_class_prefix: "",
        csharp_namespace: "",
        swift_prefix: "",
        php_class_prefix: "",
        php_namespace: "",
        php_metadata_namespace: "",
        ruby_package: "",
        features: nil,
        uninterpreted_option: []
      )
        @_bitmask = 0

        @java_package = java_package

        @java_outer_classname = java_outer_classname

        @java_multiple_files = java_multiple_files

        @java_generate_equals_and_hash = java_generate_equals_and_hash

        @java_string_check_utf8 = java_string_check_utf8

        @optimize_for =
          ProtoBoeuf::Protobuf::FileOptions::OptimizeMode.resolve(
            optimize_for
          ) || optimize_for

        @go_package = go_package

        @cc_generic_services = cc_generic_services

        @java_generic_services = java_generic_services

        @py_generic_services = py_generic_services

        @deprecated = deprecated

        @cc_enable_arenas = cc_enable_arenas

        @objc_class_prefix = objc_class_prefix

        @csharp_namespace = csharp_namespace

        @swift_prefix = swift_prefix

        @php_class_prefix = php_class_prefix

        @php_namespace = php_namespace

        @php_metadata_namespace = php_metadata_namespace

        @ruby_package = ruby_package

        @features = features

        @uninterpreted_option = uninterpreted_option
      end

      def has_java_package?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_java_outer_classname?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def has_java_multiple_files?
        (@_bitmask & 0x0000000000000004) == 0x0000000000000004
      end

      def has_java_generate_equals_and_hash?
        (@_bitmask & 0x0000000000000008) == 0x0000000000000008
      end

      def has_java_string_check_utf8?
        (@_bitmask & 0x0000000000000010) == 0x0000000000000010
      end

      def has_go_package?
        (@_bitmask & 0x0000000000000040) == 0x0000000000000040
      end

      def has_cc_generic_services?
        (@_bitmask & 0x0000000000000080) == 0x0000000000000080
      end

      def has_java_generic_services?
        (@_bitmask & 0x0000000000000100) == 0x0000000000000100
      end

      def has_py_generic_services?
        (@_bitmask & 0x0000000000000200) == 0x0000000000000200
      end

      def has_deprecated?
        (@_bitmask & 0x0000000000000400) == 0x0000000000000400
      end

      def has_cc_enable_arenas?
        (@_bitmask & 0x0000000000000800) == 0x0000000000000800
      end

      def has_objc_class_prefix?
        (@_bitmask & 0x0000000000001000) == 0x0000000000001000
      end

      def has_csharp_namespace?
        (@_bitmask & 0x0000000000002000) == 0x0000000000002000
      end

      def has_swift_prefix?
        (@_bitmask & 0x0000000000004000) == 0x0000000000004000
      end

      def has_php_class_prefix?
        (@_bitmask & 0x0000000000008000) == 0x0000000000008000
      end

      def has_php_namespace?
        (@_bitmask & 0x0000000000010000) == 0x0000000000010000
      end

      def has_php_metadata_namespace?
        (@_bitmask & 0x0000000000020000) == 0x0000000000020000
      end

      def has_ruby_package?
        (@_bitmask & 0x0000000000040000) == 0x0000000000040000
      end

      def has_features?
        (@_bitmask & 0x0000000000080000) == 0x0000000000080000
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @java_package = ""
        @java_outer_classname = ""
        @java_multiple_files = false
        @java_generate_equals_and_hash = false
        @java_string_check_utf8 = false
        @optimize_for = 0
        @go_package = ""
        @cc_generic_services = false
        @java_generic_services = false
        @py_generic_services = false
        @deprecated = false
        @cc_enable_arenas = false
        @objc_class_prefix = ""
        @csharp_namespace = ""
        @swift_prefix = ""
        @php_class_prefix = ""
        @php_namespace = ""
        @php_metadata_namespace = ""
        @ruby_package = ""
        @features = nil
        @uninterpreted_option = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @java_package =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x42
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @java_outer_classname =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x50
            ## PULL BOOLEAN
            @java_multiple_files = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0xa0
            ## PULL BOOLEAN
            @java_generate_equals_and_hash = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000008
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0xd8
            ## PULL BOOLEAN
            @java_string_check_utf8 = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000010
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x48
            ## PULL_INT64
            @optimize_for =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000020
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x5a
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @go_package =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000040
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x80
            ## PULL BOOLEAN
            @cc_generic_services = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000080
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x88
            ## PULL BOOLEAN
            @java_generic_services = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000100
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x90
            ## PULL BOOLEAN
            @py_generic_services = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000200
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0xb8
            ## PULL BOOLEAN
            @deprecated = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000400
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0xf8
            ## PULL BOOLEAN
            @cc_enable_arenas = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000800
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x122
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @objc_class_prefix =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000001000
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x12a
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @csharp_namespace =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000002000
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x13a
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @swift_prefix =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000004000
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x142
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @php_class_prefix =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000008000
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x14a
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @php_namespace =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000010000
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x162
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @php_metadata_namespace =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000020000
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x16a
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @ruby_package =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000040000
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x192
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @features =
              ProtoBoeuf::Protobuf::FeatureSet.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000080000
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x1f3a
            ## DECODE REPEATED
            list = @uninterpreted_option
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::UninterpretedOption.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x1f3a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @java_package
        if ((len = val.bytesize) > 0)
          buff << 0x0a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @java_outer_classname
        if ((len = val.bytesize) > 0)
          buff << 0x42
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @java_multiple_files
        if val == true
          buff << 0x50

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @java_generate_equals_and_hash
        if val == true
          buff << 0xa0

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @java_string_check_utf8
        if val == true
          buff << 0xd8

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @optimize_for
        if val != 0
          buff << 0x48

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @go_package
        if ((len = val.bytesize) > 0)
          buff << 0x5a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @cc_generic_services
        if val == true
          buff << 0x80

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @java_generic_services
        if val == true
          buff << 0x88

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @py_generic_services
        if val == true
          buff << 0x90

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @deprecated
        if val == true
          buff << 0xb8

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @cc_enable_arenas
        if val == true
          buff << 0xf8

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @objc_class_prefix
        if ((len = val.bytesize) > 0)
          buff << 0x122
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @csharp_namespace
        if ((len = val.bytesize) > 0)
          buff << 0x12a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @swift_prefix
        if ((len = val.bytesize) > 0)
          buff << 0x13a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @php_class_prefix
        if ((len = val.bytesize) > 0)
          buff << 0x142
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @php_namespace
        if ((len = val.bytesize) > 0)
          buff << 0x14a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @php_metadata_namespace
        if ((len = val.bytesize) > 0)
          buff << 0x162
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @ruby_package
        if ((len = val.bytesize) > 0)
          buff << 0x16a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @features
        if val
          buff << 0x192

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        list = @uninterpreted_option
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x1f3a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["java_package".to_sym] = @java_package
        result["java_outer_classname".to_sym] = @java_outer_classname
        result["java_multiple_files".to_sym] = @java_multiple_files
        result[
          "java_generate_equals_and_hash".to_sym
        ] = @java_generate_equals_and_hash
        result["java_string_check_utf8".to_sym] = @java_string_check_utf8
        result["optimize_for".to_sym] = @optimize_for
        result["go_package".to_sym] = @go_package
        result["cc_generic_services".to_sym] = @cc_generic_services
        result["java_generic_services".to_sym] = @java_generic_services
        result["py_generic_services".to_sym] = @py_generic_services
        result["deprecated".to_sym] = @deprecated
        result["cc_enable_arenas".to_sym] = @cc_enable_arenas
        result["objc_class_prefix".to_sym] = @objc_class_prefix
        result["csharp_namespace".to_sym] = @csharp_namespace
        result["swift_prefix".to_sym] = @swift_prefix
        result["php_class_prefix".to_sym] = @php_class_prefix
        result["php_namespace".to_sym] = @php_namespace
        result["php_metadata_namespace".to_sym] = @php_metadata_namespace
        result["ruby_package".to_sym] = @ruby_package
        result["features".to_sym] = @features.to_h
        result["uninterpreted_option".to_sym] = @uninterpreted_option
        result
      end
    end
    class MessageOptions
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      attr_reader :uninterpreted_option

      # optional field readers

      attr_reader :message_set_wire_format

      attr_reader :no_standard_descriptor_accessor

      attr_reader :deprecated

      attr_reader :map_entry

      attr_reader :deprecated_legacy_json_field_conflicts

      attr_reader :features

      def uninterpreted_option=(v)
        @uninterpreted_option = v
      end

      # BEGIN writers for optional fields

      def message_set_wire_format=(v)
        @_bitmask |= 0x0000000000000001
        @message_set_wire_format = v
      end

      def no_standard_descriptor_accessor=(v)
        @_bitmask |= 0x0000000000000002
        @no_standard_descriptor_accessor = v
      end

      def deprecated=(v)
        @_bitmask |= 0x0000000000000004
        @deprecated = v
      end

      def map_entry=(v)
        @_bitmask |= 0x0000000000000008
        @map_entry = v
      end

      def deprecated_legacy_json_field_conflicts=(v)
        @_bitmask |= 0x0000000000000010
        @deprecated_legacy_json_field_conflicts = v
      end

      def features=(v)
        @_bitmask |= 0x0000000000000020
        @features = v
      end
      # END writers for optional fields

      def initialize(
        message_set_wire_format: false,
        no_standard_descriptor_accessor: false,
        deprecated: false,
        map_entry: false,
        deprecated_legacy_json_field_conflicts: false,
        features: nil,
        uninterpreted_option: []
      )
        @_bitmask = 0

        @message_set_wire_format = message_set_wire_format

        @no_standard_descriptor_accessor = no_standard_descriptor_accessor

        @deprecated = deprecated

        @map_entry = map_entry

        @deprecated_legacy_json_field_conflicts =
          deprecated_legacy_json_field_conflicts

        @features = features

        @uninterpreted_option = uninterpreted_option
      end

      def has_message_set_wire_format?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_no_standard_descriptor_accessor?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def has_deprecated?
        (@_bitmask & 0x0000000000000004) == 0x0000000000000004
      end

      def has_map_entry?
        (@_bitmask & 0x0000000000000008) == 0x0000000000000008
      end

      def has_deprecated_legacy_json_field_conflicts?
        (@_bitmask & 0x0000000000000010) == 0x0000000000000010
      end

      def has_features?
        (@_bitmask & 0x0000000000000020) == 0x0000000000000020
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @message_set_wire_format = false
        @no_standard_descriptor_accessor = false
        @deprecated = false
        @map_entry = false
        @deprecated_legacy_json_field_conflicts = false
        @features = nil
        @uninterpreted_option = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0x8
            ## PULL BOOLEAN
            @message_set_wire_format = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x10
            ## PULL BOOLEAN
            @no_standard_descriptor_accessor = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x18
            ## PULL BOOLEAN
            @deprecated = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x38
            ## PULL BOOLEAN
            @map_entry = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000008
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x58
            ## PULL BOOLEAN
            @deprecated_legacy_json_field_conflicts = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000010
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x62
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @features =
              ProtoBoeuf::Protobuf::FeatureSet.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000020
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x1f3a
            ## DECODE REPEATED
            list = @uninterpreted_option
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::UninterpretedOption.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x1f3a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @message_set_wire_format
        if val == true
          buff << 0x08

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @no_standard_descriptor_accessor
        if val == true
          buff << 0x10

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @deprecated
        if val == true
          buff << 0x18

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @map_entry
        if val == true
          buff << 0x38

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @deprecated_legacy_json_field_conflicts
        if val == true
          buff << 0x58

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @features
        if val
          buff << 0x62

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        list = @uninterpreted_option
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x1f3a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["message_set_wire_format".to_sym] = @message_set_wire_format
        result[
          "no_standard_descriptor_accessor".to_sym
        ] = @no_standard_descriptor_accessor
        result["deprecated".to_sym] = @deprecated
        result["map_entry".to_sym] = @map_entry
        result[
          "deprecated_legacy_json_field_conflicts".to_sym
        ] = @deprecated_legacy_json_field_conflicts
        result["features".to_sym] = @features.to_h
        result["uninterpreted_option".to_sym] = @uninterpreted_option
        result
      end
    end
    class FieldOptions
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      class EditionDefault
        def self.decode(buff)
          allocate.decode_from(buff.b, 0, buff.bytesize)
        end

        def self.encode(obj)
          obj._encode("".b)
        end
        # required field readers

        # enum readers
        def edition
          ProtoBoeuf::Protobuf::Edition.lookup(@edition) || @edition
        end
        # optional field readers

        attr_reader :value

        # enum writers
        def edition=(v)
          @edition = ProtoBoeuf::Protobuf::Edition.resolve(v) || v
        end

        # BEGIN writers for optional fields

        def value=(v)
          @_bitmask |= 0x0000000000000002
          @value = v
        end
        # END writers for optional fields

        def initialize(edition: 0, value: "")
          @_bitmask = 0

          @edition = ProtoBoeuf::Protobuf::Edition.resolve(edition) || edition

          @value = value
        end

        def has_value?
          (@_bitmask & 0x0000000000000002) == 0x0000000000000002
        end

        def decode_from(buff, index, len)
          @_bitmask = 0

          @edition = 0
          @value = ""

          tag = buff.getbyte(index)
          index += 1

          while true
            if tag == 0x18
              ## PULL_INT64
              @edition =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF_FFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT64

              @_bitmask |= 0x0000000000000001
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x12
              ## PULL_STRING
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              @value =
                buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
              index += value

              ## END PULL_STRING

              @_bitmask |= 0x0000000000000002
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end

            return self if index >= len
          end
        end
        def _encode(buff)
          val = @edition
          if val != 0
            buff << 0x18

            while val != 0
              byte = val & 0x7F
              val >>= 7
              byte |= 0x80 if val > 0
              buff << byte
            end
          end

          val = @value
          if ((len = val.bytesize) > 0)
            buff << 0x12
            while len != 0
              byte = len & 0x7F
              len >>= 7
              byte |= 0x80 if len > 0
              buff << byte
            end

            buff << (val.ascii_only? ? val : val.b)
          end

          buff
        end

        def to_h
          result = {}
          result["edition".to_sym] = @edition
          result["value".to_sym] = @value
          result
        end
      end

      class FeatureSupport
        def self.decode(buff)
          allocate.decode_from(buff.b, 0, buff.bytesize)
        end

        def self.encode(obj)
          obj._encode("".b)
        end
        # required field readers

        # enum readers
        def edition_introduced
          ProtoBoeuf::Protobuf::Edition.lookup(@edition_introduced) ||
            @edition_introduced
        end
        def edition_deprecated
          ProtoBoeuf::Protobuf::Edition.lookup(@edition_deprecated) ||
            @edition_deprecated
        end
        def edition_removed
          ProtoBoeuf::Protobuf::Edition.lookup(@edition_removed) ||
            @edition_removed
        end
        # optional field readers

        attr_reader :deprecation_warning

        # enum writers
        def edition_introduced=(v)
          @edition_introduced = ProtoBoeuf::Protobuf::Edition.resolve(v) || v
        end
        def edition_deprecated=(v)
          @edition_deprecated = ProtoBoeuf::Protobuf::Edition.resolve(v) || v
        end
        def edition_removed=(v)
          @edition_removed = ProtoBoeuf::Protobuf::Edition.resolve(v) || v
        end

        # BEGIN writers for optional fields

        def deprecation_warning=(v)
          @_bitmask |= 0x0000000000000004
          @deprecation_warning = v
        end
        # END writers for optional fields

        def initialize(
          edition_introduced: 0,
          edition_deprecated: 0,
          deprecation_warning: "",
          edition_removed: 0
        )
          @_bitmask = 0

          @edition_introduced =
            ProtoBoeuf::Protobuf::Edition.resolve(edition_introduced) ||
              edition_introduced
          @edition_deprecated =
            ProtoBoeuf::Protobuf::Edition.resolve(edition_deprecated) ||
              edition_deprecated

          @deprecation_warning = deprecation_warning

          @edition_removed =
            ProtoBoeuf::Protobuf::Edition.resolve(edition_removed) ||
              edition_removed
        end

        def has_deprecation_warning?
          (@_bitmask & 0x0000000000000004) == 0x0000000000000004
        end

        def decode_from(buff, index, len)
          @_bitmask = 0

          @edition_introduced = 0
          @edition_deprecated = 0
          @deprecation_warning = ""
          @edition_removed = 0

          tag = buff.getbyte(index)
          index += 1

          while true
            if tag == 0x8
              ## PULL_INT64
              @edition_introduced =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF_FFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT64

              @_bitmask |= 0x0000000000000001
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x10
              ## PULL_INT64
              @edition_deprecated =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF_FFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT64

              @_bitmask |= 0x0000000000000002
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x1a
              ## PULL_STRING
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              @deprecation_warning =
                buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
              index += value

              ## END PULL_STRING

              @_bitmask |= 0x0000000000000004
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x20
              ## PULL_INT64
              @edition_removed =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF_FFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT64

              @_bitmask |= 0x0000000000000008
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end

            return self if index >= len
          end
        end
        def _encode(buff)
          val = @edition_introduced
          if val != 0
            buff << 0x08

            while val != 0
              byte = val & 0x7F
              val >>= 7
              byte |= 0x80 if val > 0
              buff << byte
            end
          end

          val = @edition_deprecated
          if val != 0
            buff << 0x10

            while val != 0
              byte = val & 0x7F
              val >>= 7
              byte |= 0x80 if val > 0
              buff << byte
            end
          end

          val = @deprecation_warning
          if ((len = val.bytesize) > 0)
            buff << 0x1a
            while len != 0
              byte = len & 0x7F
              len >>= 7
              byte |= 0x80 if len > 0
              buff << byte
            end

            buff << (val.ascii_only? ? val : val.b)
          end

          val = @edition_removed
          if val != 0
            buff << 0x20

            while val != 0
              byte = val & 0x7F
              val >>= 7
              byte |= 0x80 if val > 0
              buff << byte
            end
          end

          buff
        end

        def to_h
          result = {}
          result["edition_introduced".to_sym] = @edition_introduced
          result["edition_deprecated".to_sym] = @edition_deprecated
          result["deprecation_warning".to_sym] = @deprecation_warning
          result["edition_removed".to_sym] = @edition_removed
          result
        end
      end
      module CType
        STRING = 0
        CORD = 1
        STRING_PIECE = 2

        def self.lookup(val)
          if val == 0
            :STRING
          elsif val == 1
            :CORD
          elsif val == 2
            :STRING_PIECE
          end
        end

        def self.resolve(val)
          if val == :STRING
            0
          elsif val == :CORD
            1
          elsif val == :STRING_PIECE
            2
          end
        end
      end

      module JSType
        JS_NORMAL = 0
        JS_STRING = 1
        JS_NUMBER = 2

        def self.lookup(val)
          if val == 0
            :JS_NORMAL
          elsif val == 1
            :JS_STRING
          elsif val == 2
            :JS_NUMBER
          end
        end

        def self.resolve(val)
          if val == :JS_NORMAL
            0
          elsif val == :JS_STRING
            1
          elsif val == :JS_NUMBER
            2
          end
        end
      end

      module OptionRetention
        RETENTION_UNKNOWN = 0
        RETENTION_RUNTIME = 1
        RETENTION_SOURCE = 2

        def self.lookup(val)
          if val == 0
            :RETENTION_UNKNOWN
          elsif val == 1
            :RETENTION_RUNTIME
          elsif val == 2
            :RETENTION_SOURCE
          end
        end

        def self.resolve(val)
          if val == :RETENTION_UNKNOWN
            0
          elsif val == :RETENTION_RUNTIME
            1
          elsif val == :RETENTION_SOURCE
            2
          end
        end
      end

      module OptionTargetType
        TARGET_TYPE_UNKNOWN = 0
        TARGET_TYPE_FILE = 1
        TARGET_TYPE_EXTENSION_RANGE = 2
        TARGET_TYPE_MESSAGE = 3
        TARGET_TYPE_FIELD = 4
        TARGET_TYPE_ONEOF = 5
        TARGET_TYPE_ENUM = 6
        TARGET_TYPE_ENUM_ENTRY = 7
        TARGET_TYPE_SERVICE = 8
        TARGET_TYPE_METHOD = 9

        def self.lookup(val)
          if val == 0
            :TARGET_TYPE_UNKNOWN
          elsif val == 1
            :TARGET_TYPE_FILE
          elsif val == 2
            :TARGET_TYPE_EXTENSION_RANGE
          elsif val == 3
            :TARGET_TYPE_MESSAGE
          elsif val == 4
            :TARGET_TYPE_FIELD
          elsif val == 5
            :TARGET_TYPE_ONEOF
          elsif val == 6
            :TARGET_TYPE_ENUM
          elsif val == 7
            :TARGET_TYPE_ENUM_ENTRY
          elsif val == 8
            :TARGET_TYPE_SERVICE
          elsif val == 9
            :TARGET_TYPE_METHOD
          end
        end

        def self.resolve(val)
          if val == :TARGET_TYPE_UNKNOWN
            0
          elsif val == :TARGET_TYPE_FILE
            1
          elsif val == :TARGET_TYPE_EXTENSION_RANGE
            2
          elsif val == :TARGET_TYPE_MESSAGE
            3
          elsif val == :TARGET_TYPE_FIELD
            4
          elsif val == :TARGET_TYPE_ONEOF
            5
          elsif val == :TARGET_TYPE_ENUM
            6
          elsif val == :TARGET_TYPE_ENUM_ENTRY
            7
          elsif val == :TARGET_TYPE_SERVICE
            8
          elsif val == :TARGET_TYPE_METHOD
            9
          end
        end
      end
      # required field readers

      attr_reader :edition_defaults

      attr_reader :uninterpreted_option

      # enum readers
      def ctype
        ProtoBoeuf::Protobuf::FieldOptions::CType.lookup(@ctype) || @ctype
      end
      def jstype
        ProtoBoeuf::Protobuf::FieldOptions::JSType.lookup(@jstype) || @jstype
      end
      def retention
        ProtoBoeuf::Protobuf::FieldOptions::OptionRetention.lookup(
          @retention
        ) || @retention
      end
      def targets
        ProtoBoeuf::Protobuf::FieldOptions::OptionTargetType.lookup(@targets) ||
          @targets
      end
      # optional field readers

      attr_reader :packed

      attr_reader :lazy

      attr_reader :unverified_lazy

      attr_reader :deprecated

      attr_reader :weak

      attr_reader :debug_redact

      attr_reader :features

      attr_reader :feature_support

      def edition_defaults=(v)
        @edition_defaults = v
      end

      def uninterpreted_option=(v)
        @uninterpreted_option = v
      end

      # enum writers
      def ctype=(v)
        @ctype = ProtoBoeuf::Protobuf::FieldOptions::CType.resolve(v) || v
      end
      def jstype=(v)
        @jstype = ProtoBoeuf::Protobuf::FieldOptions::JSType.resolve(v) || v
      end
      def retention=(v)
        @retention =
          ProtoBoeuf::Protobuf::FieldOptions::OptionRetention.resolve(v) || v
      end
      def targets=(v)
        @targets =
          ProtoBoeuf::Protobuf::FieldOptions::OptionTargetType.resolve(v) || v
      end

      # BEGIN writers for optional fields

      def packed=(v)
        @_bitmask |= 0x0000000000000002
        @packed = v
      end

      def lazy=(v)
        @_bitmask |= 0x0000000000000008
        @lazy = v
      end

      def unverified_lazy=(v)
        @_bitmask |= 0x0000000000000010
        @unverified_lazy = v
      end

      def deprecated=(v)
        @_bitmask |= 0x0000000000000020
        @deprecated = v
      end

      def weak=(v)
        @_bitmask |= 0x0000000000000040
        @weak = v
      end

      def debug_redact=(v)
        @_bitmask |= 0x0000000000000080
        @debug_redact = v
      end

      def features=(v)
        @_bitmask |= 0x0000000000000200
        @features = v
      end

      def feature_support=(v)
        @_bitmask |= 0x0000000000000400
        @feature_support = v
      end
      # END writers for optional fields

      def initialize(
        ctype: 0,
        packed: false,
        jstype: 0,
        lazy: false,
        unverified_lazy: false,
        deprecated: false,
        weak: false,
        debug_redact: false,
        retention: 0,
        targets: [],
        edition_defaults: [],
        features: nil,
        feature_support: nil,
        uninterpreted_option: []
      )
        @_bitmask = 0

        @ctype =
          ProtoBoeuf::Protobuf::FieldOptions::CType.resolve(ctype) || ctype

        @packed = packed

        @jstype =
          ProtoBoeuf::Protobuf::FieldOptions::JSType.resolve(jstype) || jstype

        @lazy = lazy

        @unverified_lazy = unverified_lazy

        @deprecated = deprecated

        @weak = weak

        @debug_redact = debug_redact

        @retention =
          ProtoBoeuf::Protobuf::FieldOptions::OptionRetention.resolve(
            retention
          ) || retention
        @targets =
          ProtoBoeuf::Protobuf::FieldOptions::OptionTargetType.resolve(
            targets
          ) || targets

        @edition_defaults = edition_defaults

        @features = features

        @feature_support = feature_support

        @uninterpreted_option = uninterpreted_option
      end

      def has_packed?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def has_lazy?
        (@_bitmask & 0x0000000000000008) == 0x0000000000000008
      end

      def has_unverified_lazy?
        (@_bitmask & 0x0000000000000010) == 0x0000000000000010
      end

      def has_deprecated?
        (@_bitmask & 0x0000000000000020) == 0x0000000000000020
      end

      def has_weak?
        (@_bitmask & 0x0000000000000040) == 0x0000000000000040
      end

      def has_debug_redact?
        (@_bitmask & 0x0000000000000080) == 0x0000000000000080
      end

      def has_features?
        (@_bitmask & 0x0000000000000200) == 0x0000000000000200
      end

      def has_feature_support?
        (@_bitmask & 0x0000000000000400) == 0x0000000000000400
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @ctype = 0
        @packed = false
        @jstype = 0
        @lazy = false
        @unverified_lazy = false
        @deprecated = false
        @weak = false
        @debug_redact = false
        @retention = 0
        @targets = []
        @edition_defaults = []
        @features = nil
        @feature_support = nil
        @uninterpreted_option = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0x8
            ## PULL_INT64
            @ctype =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x10
            ## PULL BOOLEAN
            @packed = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x30
            ## PULL_INT64
            @jstype =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x28
            ## PULL BOOLEAN
            @lazy = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000008
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x78
            ## PULL BOOLEAN
            @unverified_lazy = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000010
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x18
            ## PULL BOOLEAN
            @deprecated = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000020
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x50
            ## PULL BOOLEAN
            @weak = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000040
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x80
            ## PULL BOOLEAN
            @debug_redact = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000080
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x88
            ## PULL_INT64
            @retention =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000100
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x98
            ## DECODE REPEATED
            list = @targets
            while true
              ## PULL_INT64
              list << if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

              ## END PULL_INT64

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x98
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0xa2
            ## DECODE REPEATED
            list = @edition_defaults
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::FieldOptions::EditionDefault.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0xa2
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0xaa
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @features =
              ProtoBoeuf::Protobuf::FeatureSet.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000200
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0xb2
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @feature_support =
              ProtoBoeuf::Protobuf::FieldOptions::FeatureSupport.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000400
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x1f3a
            ## DECODE REPEATED
            list = @uninterpreted_option
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::UninterpretedOption.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x1f3a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @ctype
        if val != 0
          buff << 0x08

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @packed
        if val == true
          buff << 0x10

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @jstype
        if val != 0
          buff << 0x30

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @lazy
        if val == true
          buff << 0x28

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @unverified_lazy
        if val == true
          buff << 0x78

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @deprecated
        if val == true
          buff << 0x18

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @weak
        if val == true
          buff << 0x50

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @debug_redact
        if val == true
          buff << 0x80

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @retention
        if val != 0
          buff << 0x88

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        list = @targets
        if list.size > 0
          list.each do |item|
            val = item
            if val != 0
              buff << 0x98

              while val != 0
                byte = val & 0x7F
                val >>= 7
                byte |= 0x80 if val > 0
                buff << byte
              end
            end
          end
        end

        list = @edition_defaults
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0xa2

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        val = @features
        if val
          buff << 0xaa

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        val = @feature_support
        if val
          buff << 0xb2

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        list = @uninterpreted_option
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x1f3a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["ctype".to_sym] = @ctype
        result["packed".to_sym] = @packed
        result["jstype".to_sym] = @jstype
        result["lazy".to_sym] = @lazy
        result["unverified_lazy".to_sym] = @unverified_lazy
        result["deprecated".to_sym] = @deprecated
        result["weak".to_sym] = @weak
        result["debug_redact".to_sym] = @debug_redact
        result["retention".to_sym] = @retention
        result["targets".to_sym] = @targets
        result["edition_defaults".to_sym] = @edition_defaults
        result["features".to_sym] = @features.to_h
        result["feature_support".to_sym] = @feature_support.to_h
        result["uninterpreted_option".to_sym] = @uninterpreted_option
        result
      end
    end
    class OneofOptions
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      attr_reader :uninterpreted_option

      # optional field readers

      attr_reader :features

      def uninterpreted_option=(v)
        @uninterpreted_option = v
      end

      # BEGIN writers for optional fields

      def features=(v)
        @_bitmask |= 0x0000000000000001
        @features = v
      end
      # END writers for optional fields

      def initialize(features: nil, uninterpreted_option: [])
        @_bitmask = 0

        @features = features

        @uninterpreted_option = uninterpreted_option
      end

      def has_features?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @features = nil
        @uninterpreted_option = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @features =
              ProtoBoeuf::Protobuf::FeatureSet.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x1f3a
            ## DECODE REPEATED
            list = @uninterpreted_option
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::UninterpretedOption.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x1f3a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @features
        if val
          buff << 0x0a

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        list = @uninterpreted_option
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x1f3a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["features".to_sym] = @features.to_h
        result["uninterpreted_option".to_sym] = @uninterpreted_option
        result
      end
    end
    class EnumOptions
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      attr_reader :uninterpreted_option

      # optional field readers

      attr_reader :allow_alias

      attr_reader :deprecated

      attr_reader :deprecated_legacy_json_field_conflicts

      attr_reader :features

      def uninterpreted_option=(v)
        @uninterpreted_option = v
      end

      # BEGIN writers for optional fields

      def allow_alias=(v)
        @_bitmask |= 0x0000000000000001
        @allow_alias = v
      end

      def deprecated=(v)
        @_bitmask |= 0x0000000000000002
        @deprecated = v
      end

      def deprecated_legacy_json_field_conflicts=(v)
        @_bitmask |= 0x0000000000000004
        @deprecated_legacy_json_field_conflicts = v
      end

      def features=(v)
        @_bitmask |= 0x0000000000000008
        @features = v
      end
      # END writers for optional fields

      def initialize(
        allow_alias: false,
        deprecated: false,
        deprecated_legacy_json_field_conflicts: false,
        features: nil,
        uninterpreted_option: []
      )
        @_bitmask = 0

        @allow_alias = allow_alias

        @deprecated = deprecated

        @deprecated_legacy_json_field_conflicts =
          deprecated_legacy_json_field_conflicts

        @features = features

        @uninterpreted_option = uninterpreted_option
      end

      def has_allow_alias?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_deprecated?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def has_deprecated_legacy_json_field_conflicts?
        (@_bitmask & 0x0000000000000004) == 0x0000000000000004
      end

      def has_features?
        (@_bitmask & 0x0000000000000008) == 0x0000000000000008
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @allow_alias = false
        @deprecated = false
        @deprecated_legacy_json_field_conflicts = false
        @features = nil
        @uninterpreted_option = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0x10
            ## PULL BOOLEAN
            @allow_alias = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x18
            ## PULL BOOLEAN
            @deprecated = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x30
            ## PULL BOOLEAN
            @deprecated_legacy_json_field_conflicts = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x3a
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @features =
              ProtoBoeuf::Protobuf::FeatureSet.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000008
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x1f3a
            ## DECODE REPEATED
            list = @uninterpreted_option
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::UninterpretedOption.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x1f3a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @allow_alias
        if val == true
          buff << 0x10

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @deprecated
        if val == true
          buff << 0x18

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @deprecated_legacy_json_field_conflicts
        if val == true
          buff << 0x30

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @features
        if val
          buff << 0x3a

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        list = @uninterpreted_option
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x1f3a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["allow_alias".to_sym] = @allow_alias
        result["deprecated".to_sym] = @deprecated
        result[
          "deprecated_legacy_json_field_conflicts".to_sym
        ] = @deprecated_legacy_json_field_conflicts
        result["features".to_sym] = @features.to_h
        result["uninterpreted_option".to_sym] = @uninterpreted_option
        result
      end
    end
    class EnumValueOptions
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      attr_reader :uninterpreted_option

      # optional field readers

      attr_reader :deprecated

      attr_reader :features

      attr_reader :debug_redact

      attr_reader :feature_support

      def uninterpreted_option=(v)
        @uninterpreted_option = v
      end

      # BEGIN writers for optional fields

      def deprecated=(v)
        @_bitmask |= 0x0000000000000001
        @deprecated = v
      end

      def features=(v)
        @_bitmask |= 0x0000000000000002
        @features = v
      end

      def debug_redact=(v)
        @_bitmask |= 0x0000000000000004
        @debug_redact = v
      end

      def feature_support=(v)
        @_bitmask |= 0x0000000000000008
        @feature_support = v
      end
      # END writers for optional fields

      def initialize(
        deprecated: false,
        features: nil,
        debug_redact: false,
        feature_support: nil,
        uninterpreted_option: []
      )
        @_bitmask = 0

        @deprecated = deprecated

        @features = features

        @debug_redact = debug_redact

        @feature_support = feature_support

        @uninterpreted_option = uninterpreted_option
      end

      def has_deprecated?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_features?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def has_debug_redact?
        (@_bitmask & 0x0000000000000004) == 0x0000000000000004
      end

      def has_feature_support?
        (@_bitmask & 0x0000000000000008) == 0x0000000000000008
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @deprecated = false
        @features = nil
        @debug_redact = false
        @feature_support = nil
        @uninterpreted_option = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0x8
            ## PULL BOOLEAN
            @deprecated = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x12
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @features =
              ProtoBoeuf::Protobuf::FeatureSet.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x18
            ## PULL BOOLEAN
            @debug_redact = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x22
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @feature_support =
              ProtoBoeuf::Protobuf::FieldOptions::FeatureSupport.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000008
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x1f3a
            ## DECODE REPEATED
            list = @uninterpreted_option
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::UninterpretedOption.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x1f3a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @deprecated
        if val == true
          buff << 0x08

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @features
        if val
          buff << 0x12

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        val = @debug_redact
        if val == true
          buff << 0x18

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @feature_support
        if val
          buff << 0x22

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        list = @uninterpreted_option
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x1f3a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["deprecated".to_sym] = @deprecated
        result["features".to_sym] = @features.to_h
        result["debug_redact".to_sym] = @debug_redact
        result["feature_support".to_sym] = @feature_support.to_h
        result["uninterpreted_option".to_sym] = @uninterpreted_option
        result
      end
    end
    class ServiceOptions
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      attr_reader :uninterpreted_option

      # optional field readers

      attr_reader :features

      attr_reader :deprecated

      def uninterpreted_option=(v)
        @uninterpreted_option = v
      end

      # BEGIN writers for optional fields

      def features=(v)
        @_bitmask |= 0x0000000000000001
        @features = v
      end

      def deprecated=(v)
        @_bitmask |= 0x0000000000000002
        @deprecated = v
      end
      # END writers for optional fields

      def initialize(features: nil, deprecated: false, uninterpreted_option: [])
        @_bitmask = 0

        @features = features

        @deprecated = deprecated

        @uninterpreted_option = uninterpreted_option
      end

      def has_features?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_deprecated?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @features = nil
        @deprecated = false
        @uninterpreted_option = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0x112
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @features =
              ProtoBoeuf::Protobuf::FeatureSet.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x108
            ## PULL BOOLEAN
            @deprecated = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x1f3a
            ## DECODE REPEATED
            list = @uninterpreted_option
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::UninterpretedOption.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x1f3a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @features
        if val
          buff << 0x112

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        val = @deprecated
        if val == true
          buff << 0x108

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        list = @uninterpreted_option
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x1f3a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["features".to_sym] = @features.to_h
        result["deprecated".to_sym] = @deprecated
        result["uninterpreted_option".to_sym] = @uninterpreted_option
        result
      end
    end
    class MethodOptions
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      module IdempotencyLevel
        IDEMPOTENCY_UNKNOWN = 0
        NO_SIDE_EFFECTS = 1
        IDEMPOTENT = 2

        def self.lookup(val)
          if val == 0
            :IDEMPOTENCY_UNKNOWN
          elsif val == 1
            :NO_SIDE_EFFECTS
          elsif val == 2
            :IDEMPOTENT
          end
        end

        def self.resolve(val)
          if val == :IDEMPOTENCY_UNKNOWN
            0
          elsif val == :NO_SIDE_EFFECTS
            1
          elsif val == :IDEMPOTENT
            2
          end
        end
      end
      # required field readers

      attr_reader :uninterpreted_option

      # enum readers
      def idempotency_level
        ProtoBoeuf::Protobuf::MethodOptions::IdempotencyLevel.lookup(
          @idempotency_level
        ) || @idempotency_level
      end
      # optional field readers

      attr_reader :deprecated

      attr_reader :features

      def uninterpreted_option=(v)
        @uninterpreted_option = v
      end

      # enum writers
      def idempotency_level=(v)
        @idempotency_level =
          ProtoBoeuf::Protobuf::MethodOptions::IdempotencyLevel.resolve(v) || v
      end

      # BEGIN writers for optional fields

      def deprecated=(v)
        @_bitmask |= 0x0000000000000001
        @deprecated = v
      end

      def features=(v)
        @_bitmask |= 0x0000000000000004
        @features = v
      end
      # END writers for optional fields

      def initialize(
        deprecated: false,
        idempotency_level: 0,
        features: nil,
        uninterpreted_option: []
      )
        @_bitmask = 0

        @deprecated = deprecated

        @idempotency_level =
          ProtoBoeuf::Protobuf::MethodOptions::IdempotencyLevel.resolve(
            idempotency_level
          ) || idempotency_level

        @features = features

        @uninterpreted_option = uninterpreted_option
      end

      def has_deprecated?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_features?
        (@_bitmask & 0x0000000000000004) == 0x0000000000000004
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @deprecated = false
        @idempotency_level = 0
        @features = nil
        @uninterpreted_option = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0x108
            ## PULL BOOLEAN
            @deprecated = (buff.getbyte(index) == 1)
            index += 1
            ## END PULL BOOLEAN

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x110
            ## PULL_INT64
            @idempotency_level =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x11a
            ## PULL_MESSAGE
            ## PULL_UINT64
            msg_len =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @features =
              ProtoBoeuf::Protobuf::FeatureSet.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
            ## END PULL_MESSAGE

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x1f3a
            ## DECODE REPEATED
            list = @uninterpreted_option
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::UninterpretedOption.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x1f3a
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @deprecated
        if val == true
          buff << 0x108

          buff << 1
        elsif val == false
          # Default value, encode nothing
        else
          raise "bool values should be true or false"
        end

        val = @idempotency_level
        if val != 0
          buff << 0x110

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @features
        if val
          buff << 0x11a

          # Save the buffer size before appending the submessage
          current_len = buff.bytesize

          # Write a single dummy byte to later store encoded length
          buff << 42 # "*"
          val._encode(buff)

          # Calculate the submessage's size
          submessage_size = buff.bytesize - current_len - 1

          # Hope the size fits in one byte
          byte = submessage_size & 0x7F
          submessage_size >>= 7
          byte |= 0x80 if submessage_size > 0
          buff.setbyte(current_len, byte)

          # If the sub message was bigger
          if submessage_size > 0
            current_len += 1

            # compute how much we need to shift
            encoded_int_len = 0
            remaining_size = submessage_size
            while remaining_size != 0
              remaining_size >>= 7
              encoded_int_len += 1
            end

            # Make space in the string with dummy bytes
            buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

            # Overwrite the dummy bytes with the encoded length
            while submessage_size != 0
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)
              current_len += 1
            end
          end

          buff
        end

        list = @uninterpreted_option
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x1f3a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["deprecated".to_sym] = @deprecated
        result["idempotency_level".to_sym] = @idempotency_level
        result["features".to_sym] = @features.to_h
        result["uninterpreted_option".to_sym] = @uninterpreted_option
        result
      end
    end
    class UninterpretedOption
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      class NamePart
        def self.decode(buff)
          allocate.decode_from(buff.b, 0, buff.bytesize)
        end

        def self.encode(obj)
          obj._encode("".b)
        end
        # required field readers

        attr_reader :name_part

        attr_reader :is_extension

        def name_part=(v)
          @name_part = v
        end

        def is_extension=(v)
          @is_extension = v
        end

        def initialize(name_part: "", is_extension: false)
          @name_part = name_part

          @is_extension = is_extension
        end

        def decode_from(buff, index, len)
          @name_part = ""
          @is_extension = false

          tag = buff.getbyte(index)
          index += 1

          while true
            if tag == 0xa
              ## PULL_STRING
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              @name_part =
                buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
              index += value

              ## END PULL_STRING

              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x10
              ## PULL BOOLEAN
              @is_extension = (buff.getbyte(index) == 1)
              index += 1
              ## END PULL BOOLEAN

              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end

            return self if index >= len
          end
        end
        def _encode(buff)
          val = @name_part
          if ((len = val.bytesize) > 0)
            buff << 0x0a
            while len != 0
              byte = len & 0x7F
              len >>= 7
              byte |= 0x80 if len > 0
              buff << byte
            end

            buff << (val.ascii_only? ? val : val.b)
          end

          val = @is_extension
          if val == true
            buff << 0x10

            buff << 1
          elsif val == false
            # Default value, encode nothing
          else
            raise "bool values should be true or false"
          end

          buff
        end

        def to_h
          result = {}
          result["name_part".to_sym] = @name_part
          result["is_extension".to_sym] = @is_extension
          result
        end
      end
      # required field readers

      attr_reader :name

      # optional field readers

      attr_reader :identifier_value

      attr_reader :positive_int_value

      attr_reader :negative_int_value

      attr_reader :double_value

      attr_reader :string_value

      attr_reader :aggregate_value

      def name=(v)
        @name = v
      end

      # BEGIN writers for optional fields

      def identifier_value=(v)
        @_bitmask |= 0x0000000000000001
        @identifier_value = v
      end

      def positive_int_value=(v)
        unless 0 <= v && v <= 18_446_744_073_709_551_615
          raise RangeError,
                "Value (#{v}) for field positive_int_value is out of bounds (0..18446744073709551615)"
        end

        @_bitmask |= 0x0000000000000002
        @positive_int_value = v
      end

      def negative_int_value=(v)
        unless -9_223_372_036_854_775_808 <= v && v <= 9_223_372_036_854_775_807
          raise RangeError,
                "Value (#{v}) for field negative_int_value is out of bounds (-9223372036854775808..9223372036854775807)"
        end

        @_bitmask |= 0x0000000000000004
        @negative_int_value = v
      end

      def double_value=(v)
        @_bitmask |= 0x0000000000000008
        @double_value = v
      end

      def string_value=(v)
        @_bitmask |= 0x0000000000000010
        @string_value = v
      end

      def aggregate_value=(v)
        @_bitmask |= 0x0000000000000020
        @aggregate_value = v
      end
      # END writers for optional fields

      def initialize(
        name: [],
        identifier_value: "",
        positive_int_value: 0,
        negative_int_value: 0,
        double_value: 0.0,
        string_value: "",
        aggregate_value: ""
      )
        @_bitmask = 0

        @name = name

        @identifier_value = identifier_value

        unless 0 <= positive_int_value &&
                 positive_int_value <= 18_446_744_073_709_551_615
          raise RangeError,
                "Value (#{positive_int_value}) for field positive_int_value is out of bounds (0..18446744073709551615)"
        end
        @positive_int_value = positive_int_value

        unless -9_223_372_036_854_775_808 <= negative_int_value &&
                 negative_int_value <= 9_223_372_036_854_775_807
          raise RangeError,
                "Value (#{negative_int_value}) for field negative_int_value is out of bounds (-9223372036854775808..9223372036854775807)"
        end
        @negative_int_value = negative_int_value

        @double_value = double_value

        @string_value = string_value

        @aggregate_value = aggregate_value
      end

      def has_identifier_value?
        (@_bitmask & 0x0000000000000001) == 0x0000000000000001
      end

      def has_positive_int_value?
        (@_bitmask & 0x0000000000000002) == 0x0000000000000002
      end

      def has_negative_int_value?
        (@_bitmask & 0x0000000000000004) == 0x0000000000000004
      end

      def has_double_value?
        (@_bitmask & 0x0000000000000008) == 0x0000000000000008
      end

      def has_string_value?
        (@_bitmask & 0x0000000000000010) == 0x0000000000000010
      end

      def has_aggregate_value?
        (@_bitmask & 0x0000000000000020) == 0x0000000000000020
      end

      def decode_from(buff, index, len)
        @_bitmask = 0

        @name = []
        @identifier_value = ""
        @positive_int_value = 0
        @negative_int_value = 0
        @double_value = 0.0
        @string_value = ""
        @aggregate_value = ""

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0x12
            ## DECODE REPEATED
            list = @name
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::UninterpretedOption::NamePart.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0x12
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x1a
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @identifier_value =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x20
            ## PULL_UINT64
            @positive_int_value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            ## END PULL_UINT64

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x28
            ## PULL_INT64
            @negative_int_value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x31
            @double_value = buff.unpack1("E", offset: index)
            index += 8
            @_bitmask |= 0x0000000000000008
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x3a
            ## PULL_BYTES
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @string_value = buff.byteslice(index, value)
            index += value

            ## END PULL_BYTES

            @_bitmask |= 0x0000000000000010
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x42
            ## PULL_STRING
            value =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                  ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              else
                raise "integer decoding error"
              end

            @aggregate_value =
              buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
            index += value

            ## END PULL_STRING

            @_bitmask |= 0x0000000000000020
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        list = @name
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x12

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        val = @identifier_value
        if ((len = val.bytesize) > 0)
          buff << 0x1a
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        val = @positive_int_value
        if val != 0
          buff << 0x20

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @negative_int_value
        if val != 0
          buff << 0x28

          while val != 0
            byte = val & 0x7F

            val >>= 7
            # This drops the top bits,
            # Otherwise, with a signed right shift,
            # we get infinity one bits at the top
            val &= (1 << 57) - 1

            byte |= 0x80 if val != 0
            buff << byte
          end
        end

        val = @double_value
        if val != 0
          buff << 0x31

          [val].pack("E", buffer: buff)
        end

        val = @string_value
        if ((bs = val.bytesize) > 0)
          buff << 0x3a
          len = bs
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff.concat(val.b)
        end

        val = @aggregate_value
        if ((len = val.bytesize) > 0)
          buff << 0x42
          while len != 0
            byte = len & 0x7F
            len >>= 7
            byte |= 0x80 if len > 0
            buff << byte
          end

          buff << (val.ascii_only? ? val : val.b)
        end

        buff
      end

      def to_h
        result = {}
        result["name".to_sym] = @name
        result["identifier_value".to_sym] = @identifier_value
        result["positive_int_value".to_sym] = @positive_int_value
        result["negative_int_value".to_sym] = @negative_int_value
        result["double_value".to_sym] = @double_value
        result["string_value".to_sym] = @string_value
        result["aggregate_value".to_sym] = @aggregate_value
        result
      end
    end
    class FeatureSet
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      module FieldPresence
        FIELD_PRESENCE_UNKNOWN = 0
        EXPLICIT = 1
        IMPLICIT = 2
        LEGACY_REQUIRED = 3

        def self.lookup(val)
          if val == 0
            :FIELD_PRESENCE_UNKNOWN
          elsif val == 1
            :EXPLICIT
          elsif val == 2
            :IMPLICIT
          elsif val == 3
            :LEGACY_REQUIRED
          end
        end

        def self.resolve(val)
          if val == :FIELD_PRESENCE_UNKNOWN
            0
          elsif val == :EXPLICIT
            1
          elsif val == :IMPLICIT
            2
          elsif val == :LEGACY_REQUIRED
            3
          end
        end
      end

      module EnumType
        ENUM_TYPE_UNKNOWN = 0
        OPEN = 1
        CLOSED = 2

        def self.lookup(val)
          if val == 0
            :ENUM_TYPE_UNKNOWN
          elsif val == 1
            :OPEN
          elsif val == 2
            :CLOSED
          end
        end

        def self.resolve(val)
          if val == :ENUM_TYPE_UNKNOWN
            0
          elsif val == :OPEN
            1
          elsif val == :CLOSED
            2
          end
        end
      end

      module RepeatedFieldEncoding
        REPEATED_FIELD_ENCODING_UNKNOWN = 0
        PACKED = 1
        EXPANDED = 2

        def self.lookup(val)
          if val == 0
            :REPEATED_FIELD_ENCODING_UNKNOWN
          elsif val == 1
            :PACKED
          elsif val == 2
            :EXPANDED
          end
        end

        def self.resolve(val)
          if val == :REPEATED_FIELD_ENCODING_UNKNOWN
            0
          elsif val == :PACKED
            1
          elsif val == :EXPANDED
            2
          end
        end
      end

      module Utf8Validation
        UTF8_VALIDATION_UNKNOWN = 0
        VERIFY = 2
        NONE = 3

        def self.lookup(val)
          if val == 0
            :UTF8_VALIDATION_UNKNOWN
          elsif val == 2
            :VERIFY
          elsif val == 3
            :NONE
          end
        end

        def self.resolve(val)
          if val == :UTF8_VALIDATION_UNKNOWN
            0
          elsif val == :VERIFY
            2
          elsif val == :NONE
            3
          end
        end
      end

      module MessageEncoding
        MESSAGE_ENCODING_UNKNOWN = 0
        LENGTH_PREFIXED = 1
        DELIMITED = 2

        def self.lookup(val)
          if val == 0
            :MESSAGE_ENCODING_UNKNOWN
          elsif val == 1
            :LENGTH_PREFIXED
          elsif val == 2
            :DELIMITED
          end
        end

        def self.resolve(val)
          if val == :MESSAGE_ENCODING_UNKNOWN
            0
          elsif val == :LENGTH_PREFIXED
            1
          elsif val == :DELIMITED
            2
          end
        end
      end

      module JsonFormat
        JSON_FORMAT_UNKNOWN = 0
        ALLOW = 1
        LEGACY_BEST_EFFORT = 2

        def self.lookup(val)
          if val == 0
            :JSON_FORMAT_UNKNOWN
          elsif val == 1
            :ALLOW
          elsif val == 2
            :LEGACY_BEST_EFFORT
          end
        end

        def self.resolve(val)
          if val == :JSON_FORMAT_UNKNOWN
            0
          elsif val == :ALLOW
            1
          elsif val == :LEGACY_BEST_EFFORT
            2
          end
        end
      end
      # required field readers

      # enum readers
      def field_presence
        ProtoBoeuf::Protobuf::FeatureSet::FieldPresence.lookup(
          @field_presence
        ) || @field_presence
      end
      def enum_type
        ProtoBoeuf::Protobuf::FeatureSet::EnumType.lookup(@enum_type) ||
          @enum_type
      end
      def repeated_field_encoding
        ProtoBoeuf::Protobuf::FeatureSet::RepeatedFieldEncoding.lookup(
          @repeated_field_encoding
        ) || @repeated_field_encoding
      end
      def utf8_validation
        ProtoBoeuf::Protobuf::FeatureSet::Utf8Validation.lookup(
          @utf8_validation
        ) || @utf8_validation
      end
      def message_encoding
        ProtoBoeuf::Protobuf::FeatureSet::MessageEncoding.lookup(
          @message_encoding
        ) || @message_encoding
      end
      def json_format
        ProtoBoeuf::Protobuf::FeatureSet::JsonFormat.lookup(@json_format) ||
          @json_format
      end
      # enum writers
      def field_presence=(v)
        @field_presence =
          ProtoBoeuf::Protobuf::FeatureSet::FieldPresence.resolve(v) || v
      end
      def enum_type=(v)
        @enum_type = ProtoBoeuf::Protobuf::FeatureSet::EnumType.resolve(v) || v
      end
      def repeated_field_encoding=(v)
        @repeated_field_encoding =
          ProtoBoeuf::Protobuf::FeatureSet::RepeatedFieldEncoding.resolve(v) ||
            v
      end
      def utf8_validation=(v)
        @utf8_validation =
          ProtoBoeuf::Protobuf::FeatureSet::Utf8Validation.resolve(v) || v
      end
      def message_encoding=(v)
        @message_encoding =
          ProtoBoeuf::Protobuf::FeatureSet::MessageEncoding.resolve(v) || v
      end
      def json_format=(v)
        @json_format =
          ProtoBoeuf::Protobuf::FeatureSet::JsonFormat.resolve(v) || v
      end

      def initialize(
        field_presence: 0,
        enum_type: 0,
        repeated_field_encoding: 0,
        utf8_validation: 0,
        message_encoding: 0,
        json_format: 0
      )
        @field_presence =
          ProtoBoeuf::Protobuf::FeatureSet::FieldPresence.resolve(
            field_presence
          ) || field_presence
        @enum_type =
          ProtoBoeuf::Protobuf::FeatureSet::EnumType.resolve(enum_type) ||
            enum_type
        @repeated_field_encoding =
          ProtoBoeuf::Protobuf::FeatureSet::RepeatedFieldEncoding.resolve(
            repeated_field_encoding
          ) || repeated_field_encoding
        @utf8_validation =
          ProtoBoeuf::Protobuf::FeatureSet::Utf8Validation.resolve(
            utf8_validation
          ) || utf8_validation
        @message_encoding =
          ProtoBoeuf::Protobuf::FeatureSet::MessageEncoding.resolve(
            message_encoding
          ) || message_encoding
        @json_format =
          ProtoBoeuf::Protobuf::FeatureSet::JsonFormat.resolve(json_format) ||
            json_format
      end

      def decode_from(buff, index, len)
        @field_presence = 0
        @enum_type = 0
        @repeated_field_encoding = 0
        @utf8_validation = 0
        @message_encoding = 0
        @json_format = 0

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0x8
            ## PULL_INT64
            @field_presence =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x10
            ## PULL_INT64
            @enum_type =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x18
            ## PULL_INT64
            @repeated_field_encoding =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000004
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x20
            ## PULL_INT64
            @utf8_validation =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000008
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x28
            ## PULL_INT64
            @message_encoding =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000010
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x30
            ## PULL_INT64
            @json_format =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000020
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @field_presence
        if val != 0
          buff << 0x08

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @enum_type
        if val != 0
          buff << 0x10

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @repeated_field_encoding
        if val != 0
          buff << 0x18

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @utf8_validation
        if val != 0
          buff << 0x20

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @message_encoding
        if val != 0
          buff << 0x28

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @json_format
        if val != 0
          buff << 0x30

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        buff
      end

      def to_h
        result = {}
        result["field_presence".to_sym] = @field_presence
        result["enum_type".to_sym] = @enum_type
        result["repeated_field_encoding".to_sym] = @repeated_field_encoding
        result["utf8_validation".to_sym] = @utf8_validation
        result["message_encoding".to_sym] = @message_encoding
        result["json_format".to_sym] = @json_format
        result
      end
    end
    class FeatureSetDefaults
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      class FeatureSetEditionDefault
        def self.decode(buff)
          allocate.decode_from(buff.b, 0, buff.bytesize)
        end

        def self.encode(obj)
          obj._encode("".b)
        end
        # required field readers

        # enum readers
        def edition
          ProtoBoeuf::Protobuf::Edition.lookup(@edition) || @edition
        end
        # optional field readers

        attr_reader :overridable_features

        attr_reader :fixed_features

        # enum writers
        def edition=(v)
          @edition = ProtoBoeuf::Protobuf::Edition.resolve(v) || v
        end

        # BEGIN writers for optional fields

        def overridable_features=(v)
          @_bitmask |= 0x0000000000000002
          @overridable_features = v
        end

        def fixed_features=(v)
          @_bitmask |= 0x0000000000000004
          @fixed_features = v
        end
        # END writers for optional fields

        def initialize(
          edition: 0,
          overridable_features: nil,
          fixed_features: nil
        )
          @_bitmask = 0

          @edition = ProtoBoeuf::Protobuf::Edition.resolve(edition) || edition

          @overridable_features = overridable_features

          @fixed_features = fixed_features
        end

        def has_overridable_features?
          (@_bitmask & 0x0000000000000002) == 0x0000000000000002
        end

        def has_fixed_features?
          (@_bitmask & 0x0000000000000004) == 0x0000000000000004
        end

        def decode_from(buff, index, len)
          @_bitmask = 0

          @edition = 0
          @overridable_features = nil
          @fixed_features = nil

          tag = buff.getbyte(index)
          index += 1

          while true
            if tag == 0x18
              ## PULL_INT64
              @edition =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF_FFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT64

              @_bitmask |= 0x0000000000000001
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x22
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              @overridable_features =
                ProtoBoeuf::Protobuf::FeatureSet.allocate.decode_from(
                  buff,
                  index,
                  index += msg_len
                )
              ## END PULL_MESSAGE

              @_bitmask |= 0x0000000000000002
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x2a
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              @fixed_features =
                ProtoBoeuf::Protobuf::FeatureSet.allocate.decode_from(
                  buff,
                  index,
                  index += msg_len
                )
              ## END PULL_MESSAGE

              @_bitmask |= 0x0000000000000004
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end

            return self if index >= len
          end
        end
        def _encode(buff)
          val = @edition
          if val != 0
            buff << 0x18

            while val != 0
              byte = val & 0x7F
              val >>= 7
              byte |= 0x80 if val > 0
              buff << byte
            end
          end

          val = @overridable_features
          if val
            buff << 0x22

            # Save the buffer size before appending the submessage
            current_len = buff.bytesize

            # Write a single dummy byte to later store encoded length
            buff << 42 # "*"
            val._encode(buff)

            # Calculate the submessage's size
            submessage_size = buff.bytesize - current_len - 1

            # Hope the size fits in one byte
            byte = submessage_size & 0x7F
            submessage_size >>= 7
            byte |= 0x80 if submessage_size > 0
            buff.setbyte(current_len, byte)

            # If the sub message was bigger
            if submessage_size > 0
              current_len += 1

              # compute how much we need to shift
              encoded_int_len = 0
              remaining_size = submessage_size
              while remaining_size != 0
                remaining_size >>= 7
                encoded_int_len += 1
              end

              # Make space in the string with dummy bytes
              buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

              # Overwrite the dummy bytes with the encoded length
              while submessage_size != 0
                byte = submessage_size & 0x7F
                submessage_size >>= 7
                byte |= 0x80 if submessage_size > 0
                buff.setbyte(current_len, byte)
                current_len += 1
              end
            end

            buff
          end

          val = @fixed_features
          if val
            buff << 0x2a

            # Save the buffer size before appending the submessage
            current_len = buff.bytesize

            # Write a single dummy byte to later store encoded length
            buff << 42 # "*"
            val._encode(buff)

            # Calculate the submessage's size
            submessage_size = buff.bytesize - current_len - 1

            # Hope the size fits in one byte
            byte = submessage_size & 0x7F
            submessage_size >>= 7
            byte |= 0x80 if submessage_size > 0
            buff.setbyte(current_len, byte)

            # If the sub message was bigger
            if submessage_size > 0
              current_len += 1

              # compute how much we need to shift
              encoded_int_len = 0
              remaining_size = submessage_size
              while remaining_size != 0
                remaining_size >>= 7
                encoded_int_len += 1
              end

              # Make space in the string with dummy bytes
              buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

              # Overwrite the dummy bytes with the encoded length
              while submessage_size != 0
                byte = submessage_size & 0x7F
                submessage_size >>= 7
                byte |= 0x80 if submessage_size > 0
                buff.setbyte(current_len, byte)
                current_len += 1
              end
            end

            buff
          end

          buff
        end

        def to_h
          result = {}
          result["edition".to_sym] = @edition
          result["overridable_features".to_sym] = @overridable_features.to_h
          result["fixed_features".to_sym] = @fixed_features.to_h
          result
        end
      end
      # required field readers

      attr_reader :defaults

      # enum readers
      def minimum_edition
        ProtoBoeuf::Protobuf::Edition.lookup(@minimum_edition) ||
          @minimum_edition
      end
      def maximum_edition
        ProtoBoeuf::Protobuf::Edition.lookup(@maximum_edition) ||
          @maximum_edition
      end

      def defaults=(v)
        @defaults = v
      end

      # enum writers
      def minimum_edition=(v)
        @minimum_edition = ProtoBoeuf::Protobuf::Edition.resolve(v) || v
      end
      def maximum_edition=(v)
        @maximum_edition = ProtoBoeuf::Protobuf::Edition.resolve(v) || v
      end

      def initialize(defaults: [], minimum_edition: 0, maximum_edition: 0)
        @defaults = defaults

        @minimum_edition =
          ProtoBoeuf::Protobuf::Edition.resolve(minimum_edition) ||
            minimum_edition
        @maximum_edition =
          ProtoBoeuf::Protobuf::Edition.resolve(maximum_edition) ||
            maximum_edition
      end

      def decode_from(buff, index, len)
        @defaults = []
        @minimum_edition = 0
        @maximum_edition = 0

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## DECODE REPEATED
            list = @defaults
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::FeatureSetDefaults::FeatureSetEditionDefault.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0xa
            end
            ## END DECODE REPEATED

            return self if index >= len
          end
          if tag == 0x20
            ## PULL_INT64
            @minimum_edition =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000001
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end
          if tag == 0x28
            ## PULL_INT64
            @maximum_edition =
              if (byte0 = buff.getbyte(index)) < 0x80
                index += 1
                byte0
              elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                index += 2
                (byte1 << 7) | (byte0 & 0x7F)
              elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                index += 3
                (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                index += 4
                (byte3 << 21) | ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                index += 5
                (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                index += 6
                (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                index += 7
                (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                index += 8
                (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                  ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                  ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                  ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
              elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                index += 9
                (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                  ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                  ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                  ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                  (byte0 & 0x7F)
              elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                index += 10

                # Negative 32 bit integers are still encoded with 10 bytes
                # handle 2's complement negative numbers
                # If the top bit is 1, then it must be negative.
                -(
                  (
                    (
                      ~(
                        (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                          ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                          ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                          ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                          ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                      )
                    ) & 0xFFFF_FFFF_FFFF_FFFF
                  ) + 1
                )
              else
                raise "integer decoding error"
              end

            ## END PULL_INT64

            @_bitmask |= 0x0000000000000002
            return self if index >= len
            tag = buff.getbyte(index)
            index += 1
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        list = @defaults
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x0a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        val = @minimum_edition
        if val != 0
          buff << 0x20

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        val = @maximum_edition
        if val != 0
          buff << 0x28

          while val != 0
            byte = val & 0x7F
            val >>= 7
            byte |= 0x80 if val > 0
            buff << byte
          end
        end

        buff
      end

      def to_h
        result = {}
        result["defaults".to_sym] = @defaults
        result["minimum_edition".to_sym] = @minimum_edition
        result["maximum_edition".to_sym] = @maximum_edition
        result
      end
    end
    class SourceCodeInfo
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      class Location
        def self.decode(buff)
          allocate.decode_from(buff.b, 0, buff.bytesize)
        end

        def self.encode(obj)
          obj._encode("".b)
        end
        # required field readers

        attr_reader :path

        attr_reader :span

        attr_reader :leading_detached_comments

        # optional field readers

        attr_reader :leading_comments

        attr_reader :trailing_comments

        def path=(v)
          v.each do |v|
            unless -2_147_483_648 <= v && v <= 2_147_483_647
              raise RangeError,
                    "Value (#{v}}) for field path is out of bounds (-2147483648..2147483647)"
            end
          end

          @path = v
        end

        def span=(v)
          v.each do |v|
            unless -2_147_483_648 <= v && v <= 2_147_483_647
              raise RangeError,
                    "Value (#{v}}) for field span is out of bounds (-2147483648..2147483647)"
            end
          end

          @span = v
        end

        def leading_detached_comments=(v)
          @leading_detached_comments = v
        end

        # BEGIN writers for optional fields

        def leading_comments=(v)
          @_bitmask |= 0x0000000000000001
          @leading_comments = v
        end

        def trailing_comments=(v)
          @_bitmask |= 0x0000000000000002
          @trailing_comments = v
        end
        # END writers for optional fields

        def initialize(
          path: [],
          span: [],
          leading_comments: "",
          trailing_comments: "",
          leading_detached_comments: []
        )
          @_bitmask = 0

          path.each do |v|
            unless -2_147_483_648 <= v && v <= 2_147_483_647
              raise RangeError,
                    "Value (#{v}}) for field path is out of bounds (-2147483648..2147483647)"
            end
          end
          @path = path

          span.each do |v|
            unless -2_147_483_648 <= v && v <= 2_147_483_647
              raise RangeError,
                    "Value (#{v}}) for field span is out of bounds (-2147483648..2147483647)"
            end
          end
          @span = span

          @leading_comments = leading_comments

          @trailing_comments = trailing_comments

          @leading_detached_comments = leading_detached_comments
        end

        def has_leading_comments?
          (@_bitmask & 0x0000000000000001) == 0x0000000000000001
        end

        def has_trailing_comments?
          (@_bitmask & 0x0000000000000002) == 0x0000000000000002
        end

        def decode_from(buff, index, len)
          @_bitmask = 0

          @path = []
          @span = []
          @leading_comments = ""
          @trailing_comments = ""
          @leading_detached_comments = []

          tag = buff.getbyte(index)
          index += 1

          while true
            if tag == 0xa
              ## PULL_UINT64
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              goal = index + value
              list = @path
              while true
                break if index >= goal
                ## PULL_INT32
                list << if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

                ## END PULL_INT32
              end

              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x12
              ## PULL_UINT64
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              goal = index + value
              list = @span
              while true
                break if index >= goal
                ## PULL_INT32
                list << if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

                ## END PULL_INT32
              end

              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x1a
              ## PULL_STRING
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              @leading_comments =
                buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
              index += value

              ## END PULL_STRING

              @_bitmask |= 0x0000000000000001
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x22
              ## PULL_STRING
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              @trailing_comments =
                buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
              index += value

              ## END PULL_STRING

              @_bitmask |= 0x0000000000000002
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x32
              ## DECODE REPEATED
              list = @leading_detached_comments
              while true
                ## PULL_STRING
                value =
                  if (byte0 = buff.getbyte(index)) < 0x80
                    index += 1
                    byte0
                  elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                    index += 2
                    (byte1 << 7) | (byte0 & 0x7F)
                  elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                    index += 3
                    (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                  elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                    index += 4
                    (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                      ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                  elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                    index += 5
                    (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                      ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                      (byte0 & 0x7F)
                  elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                    index += 6
                    (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                      ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                      ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                  elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                    index += 7
                    (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                      ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                      ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                      (byte0 & 0x7F)
                  elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                    index += 8
                    (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                      ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                      ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                      ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                  elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                    index += 9
                    (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                      ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                      ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                      ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                      (byte0 & 0x7F)
                  elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                    index += 10

                    (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                      ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                      ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                      ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                      ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                  else
                    raise "integer decoding error"
                  end

                list << buff.byteslice(index, value).force_encoding(
                  Encoding::UTF_8
                )
                index += value

                ## END PULL_STRING

                tag = buff.getbyte(index)
                index += 1

                break unless tag == 0x32
              end
              ## END DECODE REPEATED

              return self if index >= len
            end

            return self if index >= len
          end
        end
        def _encode(buff)
          list = @path
          if list.size > 0
            buff << 0x0a

            # Save the buffer size before appending the repeated bytes
            current_len = buff.bytesize

            # Write a single dummy byte to later store encoded length
            buff << 42 # "*"

            # write each item
            list.each do |item|
              val = item
              if val != 0
                while val != 0
                  byte = val & 0x7F

                  val >>= 7
                  # This drops the top bits,
                  # Otherwise, with a signed right shift,
                  # we get infinity one bits at the top
                  val &= (1 << 57) - 1

                  byte |= 0x80 if val != 0
                  buff << byte
                end
              end
            end

            # Calculate the submessage's size
            submessage_size = buff.bytesize - current_len - 1

            # Hope the size fits in one byte
            byte = submessage_size & 0x7F
            submessage_size >>= 7
            byte |= 0x80 if submessage_size > 0
            buff.setbyte(current_len, byte)

            # If the sub message was bigger
            if submessage_size > 0
              current_len += 1

              # compute how much we need to shift
              encoded_int_len = 0
              remaining_size = submessage_size
              while remaining_size != 0
                remaining_size >>= 7
                encoded_int_len += 1
              end

              # Make space in the string with dummy bytes
              buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

              # Overwrite the dummy bytes with the encoded length
              while submessage_size != 0
                byte = submessage_size & 0x7F
                submessage_size >>= 7
                byte |= 0x80 if submessage_size > 0
                buff.setbyte(current_len, byte)
                current_len += 1
              end
            end
          end

          list = @span
          if list.size > 0
            buff << 0x12

            # Save the buffer size before appending the repeated bytes
            current_len = buff.bytesize

            # Write a single dummy byte to later store encoded length
            buff << 42 # "*"

            # write each item
            list.each do |item|
              val = item
              if val != 0
                while val != 0
                  byte = val & 0x7F

                  val >>= 7
                  # This drops the top bits,
                  # Otherwise, with a signed right shift,
                  # we get infinity one bits at the top
                  val &= (1 << 57) - 1

                  byte |= 0x80 if val != 0
                  buff << byte
                end
              end
            end

            # Calculate the submessage's size
            submessage_size = buff.bytesize - current_len - 1

            # Hope the size fits in one byte
            byte = submessage_size & 0x7F
            submessage_size >>= 7
            byte |= 0x80 if submessage_size > 0
            buff.setbyte(current_len, byte)

            # If the sub message was bigger
            if submessage_size > 0
              current_len += 1

              # compute how much we need to shift
              encoded_int_len = 0
              remaining_size = submessage_size
              while remaining_size != 0
                remaining_size >>= 7
                encoded_int_len += 1
              end

              # Make space in the string with dummy bytes
              buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

              # Overwrite the dummy bytes with the encoded length
              while submessage_size != 0
                byte = submessage_size & 0x7F
                submessage_size >>= 7
                byte |= 0x80 if submessage_size > 0
                buff.setbyte(current_len, byte)
                current_len += 1
              end
            end
          end

          val = @leading_comments
          if ((len = val.bytesize) > 0)
            buff << 0x1a
            while len != 0
              byte = len & 0x7F
              len >>= 7
              byte |= 0x80 if len > 0
              buff << byte
            end

            buff << (val.ascii_only? ? val : val.b)
          end

          val = @trailing_comments
          if ((len = val.bytesize) > 0)
            buff << 0x22
            while len != 0
              byte = len & 0x7F
              len >>= 7
              byte |= 0x80 if len > 0
              buff << byte
            end

            buff << (val.ascii_only? ? val : val.b)
          end

          list = @leading_detached_comments
          if list.size > 0
            list.each do |item|
              val = item
              if ((len = val.bytesize) > 0)
                buff << 0x32
                while len != 0
                  byte = len & 0x7F
                  len >>= 7
                  byte |= 0x80 if len > 0
                  buff << byte
                end

                buff << (val.ascii_only? ? val : val.b)
              end
            end
          end

          buff
        end

        def to_h
          result = {}
          result["path".to_sym] = @path
          result["span".to_sym] = @span
          result["leading_comments".to_sym] = @leading_comments
          result["trailing_comments".to_sym] = @trailing_comments
          result[
            "leading_detached_comments".to_sym
          ] = @leading_detached_comments
          result
        end
      end
      # required field readers

      attr_reader :location

      def location=(v)
        @location = v
      end

      def initialize(location: [])
        @location = location
      end

      def decode_from(buff, index, len)
        @location = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## DECODE REPEATED
            list = @location
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::SourceCodeInfo::Location.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0xa
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        list = @location
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x0a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["location".to_sym] = @location
        result
      end
    end
    class GeneratedCodeInfo
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      class Annotation
        def self.decode(buff)
          allocate.decode_from(buff.b, 0, buff.bytesize)
        end

        def self.encode(obj)
          obj._encode("".b)
        end
        module Semantic
          NONE = 0
          SET = 1
          ALIAS = 2

          def self.lookup(val)
            if val == 0
              :NONE
            elsif val == 1
              :SET
            elsif val == 2
              :ALIAS
            end
          end

          def self.resolve(val)
            if val == :NONE
              0
            elsif val == :SET
              1
            elsif val == :ALIAS
              2
            end
          end
        end
        # required field readers

        attr_reader :path

        # enum readers
        def semantic
          ProtoBoeuf::Protobuf::GeneratedCodeInfo::Annotation::Semantic.lookup(
            @semantic
          ) || @semantic
        end
        # optional field readers

        attr_reader :source_file

        attr_reader :begin

        attr_reader :end

        def path=(v)
          v.each do |v|
            unless -2_147_483_648 <= v && v <= 2_147_483_647
              raise RangeError,
                    "Value (#{v}}) for field path is out of bounds (-2147483648..2147483647)"
            end
          end

          @path = v
        end

        # enum writers
        def semantic=(v)
          @semantic =
            ProtoBoeuf::Protobuf::GeneratedCodeInfo::Annotation::Semantic.resolve(
              v
            ) || v
        end

        # BEGIN writers for optional fields

        def source_file=(v)
          @_bitmask |= 0x0000000000000001
          @source_file = v
        end

        def begin=(v)
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}) for field begin is out of bounds (-2147483648..2147483647)"
          end

          @_bitmask |= 0x0000000000000002
          @begin = v
        end

        def end=(v)
          unless -2_147_483_648 <= v && v <= 2_147_483_647
            raise RangeError,
                  "Value (#{v}) for field end is out of bounds (-2147483648..2147483647)"
          end

          @_bitmask |= 0x0000000000000004
          @end = v
        end
        # END writers for optional fields

        def initialize(path: [], source_file: "", begin: 0, end: 0, semantic: 0)
          @_bitmask = 0

          path.each do |v|
            unless -2_147_483_648 <= v && v <= 2_147_483_647
              raise RangeError,
                    "Value (#{v}}) for field path is out of bounds (-2147483648..2147483647)"
            end
          end
          @path = path

          @source_file = source_file

          unless -2_147_483_648 <= binding.local_variable_get(:begin) &&
                   binding.local_variable_get(:begin) <= 2_147_483_647
            raise RangeError,
                  "Value (#{binding.local_variable_get(:begin)}) for field begin is out of bounds (-2147483648..2147483647)"
          end
          @begin = binding.local_variable_get(:begin)

          unless -2_147_483_648 <= binding.local_variable_get(:end) &&
                   binding.local_variable_get(:end) <= 2_147_483_647
            raise RangeError,
                  "Value (#{binding.local_variable_get(:end)}) for field end is out of bounds (-2147483648..2147483647)"
          end
          @end = binding.local_variable_get(:end)

          @semantic =
            ProtoBoeuf::Protobuf::GeneratedCodeInfo::Annotation::Semantic.resolve(
              semantic
            ) || semantic
        end

        def has_source_file?
          (@_bitmask & 0x0000000000000001) == 0x0000000000000001
        end

        def has_begin?
          (@_bitmask & 0x0000000000000002) == 0x0000000000000002
        end

        def has_end?
          (@_bitmask & 0x0000000000000004) == 0x0000000000000004
        end

        def decode_from(buff, index, len)
          @_bitmask = 0

          @path = []
          @source_file = ""
          @begin = 0
          @end = 0
          @semantic = 0

          tag = buff.getbyte(index)
          index += 1

          while true
            if tag == 0xa
              ## PULL_UINT64
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              goal = index + value
              list = @path
              while true
                break if index >= goal
                ## PULL_INT32
                list << if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

                ## END PULL_INT32
              end

              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x12
              ## PULL_STRING
              value =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              @source_file =
                buff.byteslice(index, value).force_encoding(Encoding::UTF_8)
              index += value

              ## END PULL_STRING

              @_bitmask |= 0x0000000000000001
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x18
              ## PULL_INT32
              @begin =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT32

              @_bitmask |= 0x0000000000000002
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x20
              ## PULL_INT32
              @end =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT32

              @_bitmask |= 0x0000000000000004
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end
            if tag == 0x28
              ## PULL_INT64
              @semantic =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  # Negative 32 bit integers are still encoded with 10 bytes
                  # handle 2's complement negative numbers
                  # If the top bit is 1, then it must be negative.
                  -(
                    (
                      (
                        ~(
                          (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                            ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                            ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                            ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                            ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                        )
                      ) & 0xFFFF_FFFF_FFFF_FFFF
                    ) + 1
                  )
                else
                  raise "integer decoding error"
                end

              ## END PULL_INT64

              @_bitmask |= 0x0000000000000008
              return self if index >= len
              tag = buff.getbyte(index)
              index += 1
            end

            return self if index >= len
          end
        end
        def _encode(buff)
          list = @path
          if list.size > 0
            buff << 0x0a

            # Save the buffer size before appending the repeated bytes
            current_len = buff.bytesize

            # Write a single dummy byte to later store encoded length
            buff << 42 # "*"

            # write each item
            list.each do |item|
              val = item
              if val != 0
                while val != 0
                  byte = val & 0x7F

                  val >>= 7
                  # This drops the top bits,
                  # Otherwise, with a signed right shift,
                  # we get infinity one bits at the top
                  val &= (1 << 57) - 1

                  byte |= 0x80 if val != 0
                  buff << byte
                end
              end
            end

            # Calculate the submessage's size
            submessage_size = buff.bytesize - current_len - 1

            # Hope the size fits in one byte
            byte = submessage_size & 0x7F
            submessage_size >>= 7
            byte |= 0x80 if submessage_size > 0
            buff.setbyte(current_len, byte)

            # If the sub message was bigger
            if submessage_size > 0
              current_len += 1

              # compute how much we need to shift
              encoded_int_len = 0
              remaining_size = submessage_size
              while remaining_size != 0
                remaining_size >>= 7
                encoded_int_len += 1
              end

              # Make space in the string with dummy bytes
              buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

              # Overwrite the dummy bytes with the encoded length
              while submessage_size != 0
                byte = submessage_size & 0x7F
                submessage_size >>= 7
                byte |= 0x80 if submessage_size > 0
                buff.setbyte(current_len, byte)
                current_len += 1
              end
            end
          end

          val = @source_file
          if ((len = val.bytesize) > 0)
            buff << 0x12
            while len != 0
              byte = len & 0x7F
              len >>= 7
              byte |= 0x80 if len > 0
              buff << byte
            end

            buff << (val.ascii_only? ? val : val.b)
          end

          val = @begin
          if val != 0
            buff << 0x18

            while val != 0
              byte = val & 0x7F

              val >>= 7
              # This drops the top bits,
              # Otherwise, with a signed right shift,
              # we get infinity one bits at the top
              val &= (1 << 57) - 1

              byte |= 0x80 if val != 0
              buff << byte
            end
          end

          val = @end
          if val != 0
            buff << 0x20

            while val != 0
              byte = val & 0x7F

              val >>= 7
              # This drops the top bits,
              # Otherwise, with a signed right shift,
              # we get infinity one bits at the top
              val &= (1 << 57) - 1

              byte |= 0x80 if val != 0
              buff << byte
            end
          end

          val = @semantic
          if val != 0
            buff << 0x28

            while val != 0
              byte = val & 0x7F
              val >>= 7
              byte |= 0x80 if val > 0
              buff << byte
            end
          end

          buff
        end

        def to_h
          result = {}
          result["path".to_sym] = @path
          result["source_file".to_sym] = @source_file
          result["begin".to_sym] = @begin
          result["end".to_sym] = @end
          result["semantic".to_sym] = @semantic
          result
        end
      end
      # required field readers

      attr_reader :annotation

      def annotation=(v)
        @annotation = v
      end

      def initialize(annotation: [])
        @annotation = annotation
      end

      def decode_from(buff, index, len)
        @annotation = []

        tag = buff.getbyte(index)
        index += 1

        while true
          if tag == 0xa
            ## DECODE REPEATED
            list = @annotation
            while true
              ## PULL_MESSAGE
              ## PULL_UINT64
              msg_len =
                if (byte0 = buff.getbyte(index)) < 0x80
                  index += 1
                  byte0
                elsif (byte1 = buff.getbyte(index + 1)) < 0x80
                  index += 2
                  (byte1 << 7) | (byte0 & 0x7F)
                elsif (byte2 = buff.getbyte(index + 2)) < 0x80
                  index += 3
                  (byte2 << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte3 = buff.getbyte(index + 3)) < 0x80
                  index += 4
                  (byte3 << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte4 = buff.getbyte(index + 4)) < 0x80
                  index += 5
                  (byte4 << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte5 = buff.getbyte(index + 5)) < 0x80
                  index += 6
                  (byte5 << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte6 = buff.getbyte(index + 6)) < 0x80
                  index += 7
                  (byte6 << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte7 = buff.getbyte(index + 7)) < 0x80
                  index += 8
                  (byte7 << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                elsif (byte8 = buff.getbyte(index + 8)) < 0x80
                  index += 9
                  (byte8 << 56) | ((byte7 & 0x7F) << 49) |
                    ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                    ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                    ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) |
                    (byte0 & 0x7F)
                elsif (byte9 = buff.getbyte(index + 9)) < 0x80
                  index += 10

                  (byte9 << 63) | ((byte8 & 0x7F) << 56) |
                    ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                    ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                    ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                    ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
                else
                  raise "integer decoding error"
                end

              ## END PULL_UINT64

              list << ProtoBoeuf::Protobuf::GeneratedCodeInfo::Annotation.allocate.decode_from(
                buff,
                index,
                index += msg_len
              )
              ## END PULL_MESSAGE

              tag = buff.getbyte(index)
              index += 1

              break unless tag == 0xa
            end
            ## END DECODE REPEATED

            return self if index >= len
          end

          return self if index >= len
        end
      end
      def _encode(buff)
        list = @annotation
        if list.size > 0
          list.each do |item|
            val = item
            if val
              buff << 0x0a

              # Save the buffer size before appending the submessage
              current_len = buff.bytesize

              # Write a single dummy byte to later store encoded length
              buff << 42 # "*"
              val._encode(buff)

              # Calculate the submessage's size
              submessage_size = buff.bytesize - current_len - 1

              # Hope the size fits in one byte
              byte = submessage_size & 0x7F
              submessage_size >>= 7
              byte |= 0x80 if submessage_size > 0
              buff.setbyte(current_len, byte)

              # If the sub message was bigger
              if submessage_size > 0
                current_len += 1

                # compute how much we need to shift
                encoded_int_len = 0
                remaining_size = submessage_size
                while remaining_size != 0
                  remaining_size >>= 7
                  encoded_int_len += 1
                end

                # Make space in the string with dummy bytes
                buff.bytesplice(current_len, 0, "*********", 0, encoded_int_len)

                # Overwrite the dummy bytes with the encoded length
                while submessage_size != 0
                  byte = submessage_size & 0x7F
                  submessage_size >>= 7
                  byte |= 0x80 if submessage_size > 0
                  buff.setbyte(current_len, byte)
                  current_len += 1
                end
              end

              buff
            end
          end
        end

        buff
      end

      def to_h
        result = {}
        result["annotation".to_sym] = @annotation
        result
      end
    end
  end
end
