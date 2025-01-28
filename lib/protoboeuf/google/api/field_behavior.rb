# encoding: ascii-8bit
# rubocop:disable all
# frozen_string_literal: true

module ProtoBoeuf
  module Google
    module Api
      module FieldBehavior
        FIELD_BEHAVIOR_UNSPECIFIED = 0
        OPTIONAL = 1
        REQUIRED = 2
        OUTPUT_ONLY = 3
        INPUT_ONLY = 4
        IMMUTABLE = 5
        UNORDERED_LIST = 6
        NON_EMPTY_DEFAULT = 7
        IDENTIFIER = 8

        def self.lookup(val)
          return :FIELD_BEHAVIOR_UNSPECIFIED if val == 0
          return :OPTIONAL if val == 1
          return :REQUIRED if val == 2
          return :OUTPUT_ONLY if val == 3
          return :INPUT_ONLY if val == 4
          return :IMMUTABLE if val == 5
          return :UNORDERED_LIST if val == 6
          return :NON_EMPTY_DEFAULT if val == 7
          return :IDENTIFIER if val == 8
        end

        def self.resolve(val)
          return 0 if val == :FIELD_BEHAVIOR_UNSPECIFIED
          return 1 if val == :OPTIONAL
          return 2 if val == :REQUIRED
          return 3 if val == :OUTPUT_ONLY
          return 4 if val == :INPUT_ONLY
          return 5 if val == :IMMUTABLE
          return 6 if val == :UNORDERED_LIST
          return 7 if val == :NON_EMPTY_DEFAULT
          return 8 if val == :IDENTIFIER
        end
      end
    end
  end
end
