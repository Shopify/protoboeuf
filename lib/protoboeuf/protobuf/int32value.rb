# encoding: ascii-8bit
# rubocop:disable all
# frozen_string_literal: true

module ProtoBoeuf
  module Protobuf
    class Int32Value
      def self.decode(buff)
        allocate.decode_from(buff.b, 0, buff.bytesize)
      end

      def self.encode(obj)
        obj._encode("".b)
      end
      # required field readers

      attr_reader :value

      def value=(v)
        unless -2_147_483_648 <= v && v <= 2_147_483_647
          raise RangeError,
                "Value (#{v}) for field value is out of bounds (-2147483648..2147483647)"
        end

        @value = v
      end

      def initialize(value: 0)
        unless -2_147_483_648 <= value && value <= 2_147_483_647
          raise RangeError,
                "Value (#{value}) for field value is out of bounds (-2147483648..2147483647)"
        end
        @value = value
      end

      def to_proto(_options = {})
        self.class.encode(self)
      end

      def decode_from(buff, index, len)
        @value = 0

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
            case wire_type
            when 0
              i = 0
              while true
                newbyte = buff.getbyte(index)
                index += 1
                break if newbyte.nil? || newbyte < 0x80
                i += 1
                break if i > 9
              end
            when 1
              index += 8
            when 2
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

              buff.byteslice(index, value)
              index += value

              ## END PULL_BYTES
            when 5
              index += 4
            else
              raise "unknown wire type #{wire_type}"
            end
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

          if tag == 0x8
            found = true
            ## PULL_INT32
            @value =
              (
                (
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
                ) & 0xffffffff
              )
            ## END PULL_INT32

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

          return self if index >= len
        end
      end
      def _encode(buff)
        val = @value
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

        buff
      end

      def to_h
        result = {}
        result["value".to_sym] = @value
        result
      end

      def to_json_without_debug(options = {})
        require "json"
        obj = transform_for_json!(to_h)
        JSON.generate(obj, options)
      end

      # sig: any
      def to_json_with_debug(options = {})
        require "json"
        obj = transform_for_json!(to_h)
        $stderr.puts "to_json options: #{options}"
        JSON.generate(obj, options)
      end

      alias_method :to_json, :to_json_without_debug

      # sig: any
      private def transform_for_json!(obj)
        case obj
        when Hash
          obj.each_with_object({}) do |(k, v), result|
            result[json_field_name(k.to_s)] = transform_for_json!(v)
          end
        when Array
          obj.map { |v| transform_for_json!(v) }
        when String
          # TODO: when field.type == :TYPE_BYTES
          [obj].pack("m")
        when Numeric
          obj.to_s
        else
          obj
        end
      end

      # By default the protobuf JSON printer should convert the field name to lowerCamelCase and use that as the JSON name.
      # See: https://protobuf.dev/programming-guides/json/#json-options
      private def json_field_name(name)
        return name unless name.include?("_")
        # Names like FIELD_NAME11 (all caps + underscores + numbers) should remain as-is
        return name if name =~ /[A-Zd_]+/

        name
          .split(/_+/)
          .each_with_index
          .map { |part, i| i.zero? ? part : part.downcase.capitalize }
          .join
      end
    end
  end
end
