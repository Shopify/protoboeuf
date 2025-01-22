# encoding: ascii-8bit
# rubocop:disable all
# frozen_string_literal: true

# @@protoc_insertion_point(requires)

module ProtoBoeuf
  module Google
    module Api
      module FieldBehavior
        # @@protoc_insertion_point(class_definitions)

        FIELD_BEHAVIOR_UNSPECIFIED = 0
        OPTIONAL = 1
        REQUIRED = 2
        OUTPUT_ONLY = 3
        INPUT_ONLY = 4
        IMMUTABLE = 5
        UNORDERED_LIST = 6
        NON_EMPTY_DEFAULT = 7
        IDENTIFIER = 8

        class << self
          # @@protoc_insertion_point(class_methods)

          def lookup(val)
            if val == 0
              :FIELD_BEHAVIOR_UNSPECIFIED
            elsif val == 1
              :OPTIONAL
            elsif val == 2
              :REQUIRED
            elsif val == 3
              :OUTPUT_ONLY
            elsif val == 4
              :INPUT_ONLY
            elsif val == 5
              :IMMUTABLE
            elsif val == 6
              :UNORDERED_LIST
            elsif val == 7
              :NON_EMPTY_DEFAULT
            elsif val == 8
              :IDENTIFIER
            end
          end

          def resolve(val)
            if val == :FIELD_BEHAVIOR_UNSPECIFIED
              0
            elsif val == :OPTIONAL
              1
            elsif val == :REQUIRED
              2
            elsif val == :OUTPUT_ONLY
              3
            elsif val == :INPUT_ONLY
              4
            elsif val == :IMMUTABLE
              5
            elsif val == :UNORDERED_LIST
              6
            elsif val == :NON_EMPTY_DEFAULT
              7
            elsif val == :IDENTIFIER
              8
            end
          end
        end
      end
    end
  end
end
