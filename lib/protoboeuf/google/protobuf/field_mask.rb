# encoding: ascii-8bit
# rubocop:disable all
# frozen_string_literal: true

module ProtoBoeuf
  module Google
    module Protobuf
      class FieldMask
        def self.decode(buff)
          allocate.decode_from(buff.b, 0, buff.bytesize)
        end

        def self.encode(obj)
          obj._encode("".b)
        end
        # required field readers

        attr_reader :paths

        def paths=(v)
          @paths = v
        end

        def initialize(paths: [])
          @paths = paths
        end

        def to_proto(_options = {})
          self.class.encode(self)
        end

        def decode_from(buff, index, len)
          @paths = []

          return self if index >= len
          ## PULL_UINT64
          tag =
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
              (byte4 << 28) | ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
            elsif (byte5 = buff.getbyte(index + 5)) < 0x80
              index += 6
              (byte5 << 35) | ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
            elsif (byte6 = buff.getbyte(index + 6)) < 0x80
              index += 7
              (byte6 << 42) | ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
            elsif (byte7 = buff.getbyte(index + 7)) < 0x80
              index += 8
              (byte7 << 49) | ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
            elsif (byte8 = buff.getbyte(index + 8)) < 0x80
              index += 9
              (byte8 << 56) | ((byte7 & 0x7F) << 49) | ((byte6 & 0x7F) << 42) |
                ((byte5 & 0x7F) << 35) | ((byte4 & 0x7F) << 28) |
                ((byte3 & 0x7F) << 21) | ((byte2 & 0x7F) << 14) |
                ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
            elsif (byte9 = buff.getbyte(index + 9)) < 0x80
              index += 10

              (byte9 << 63) | ((byte8 & 0x7F) << 56) | ((byte7 & 0x7F) << 49) |
                ((byte6 & 0x7F) << 42) | ((byte5 & 0x7F) << 35) |
                ((byte4 & 0x7F) << 28) | ((byte3 & 0x7F) << 21) |
                ((byte2 & 0x7F) << 14) | ((byte1 & 0x7F) << 7) | (byte0 & 0x7F)
            else
              raise "integer decoding error"
            end

          ## END PULL_UINT64

          found = true
          while true
            # If we have looped around since the last found tag this one is
            # unexpected, so discard it and continue.
            if !found
              wire_type = tag & 0x7

              unknown_bytes = +"".b
              val = tag
              while val != 0
                byte = val & 0x7F

                val >>= 7
                # This drops the top bits,
                # Otherwise, with a signed right shift,
                # we get infinity one bits at the top
                val &= (1 << 57) - 1

                byte |= 0x80 if val != 0
                unknown_bytes << byte
              end

              case wire_type
              when 0
                i = 0
                while true
                  newbyte = buff.getbyte(index)
                  index += 1
                  break if newbyte.nil?
                  unknown_bytes << newbyte
                  break if newbyte < 0x80
                  i += 1
                  break if i > 9
                end
              when 1
                unknown_bytes << buff.byteslice(index, 8)
                index += 8
              when 2
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

                val = value
                while val != 0
                  byte = val & 0x7F

                  val >>= 7
                  # This drops the top bits,
                  # Otherwise, with a signed right shift,
                  # we get infinity one bits at the top
                  val &= (1 << 57) - 1

                  byte |= 0x80 if val != 0
                  unknown_bytes << byte
                end

                unknown_bytes << buff.byteslice(index, value)
                index += value
              when 5
                unknown_bytes << buff.byteslice(index, 4)
                index += 4
              else
                raise "unknown wire type #{wire_type}"
              end
              (@_unknown_fields ||= +"".b) << unknown_bytes
              return self if index >= len
              ## PULL_UINT64
              tag =
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
            end
            found = false

            if tag == 0xa
              found = true
              ## DECODE REPEATED
              list = @paths
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

                return self if index >= len
                ## PULL_UINT64
                tag =
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

                break unless tag == 0xa
              end
              ## END DECODE REPEATED

              return self if index >= len
            end

            return self if index >= len
          end
        end
        def _encode(buff)
          list = @paths
          if list.size > 0
            list.each do |item|
              val = item
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
            end
          end
          buff << @_unknown_fields if @_unknown_fields
          buff
        end

        def to_h
          result = {}

          result[:"paths"] = @paths

          result
        end

        def as_json(options = {})
          result = {}

          tmp_paths = @paths

          result["paths"] = tmp_paths if !options[:compact] || tmp_paths.any?

          result
        end

        def to_json(as_json_options = {})
          require "json"
          JSON.dump(as_json(as_json_options))
        end
      end
    end
  end
end
