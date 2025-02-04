# frozen_string_literal: true

require "helper"
require "json"

class HashSerializationTest < ProtoBoeuf::Test
  unit = parse_proto_string(<<~PROTO)
    syntax = "proto3";

    message Employer {
      string name = 1;
    }

    message Person {
      string first_name = 1;
      optional string nick_name = 2;
      optional int32 birth_year = 3;
      optional Employer current_employer = 4;
      repeated Employer previous_employers = 5;
      map<string, Employer> favorite_employers_by_name = 6;
      map<string, string> metadata = 7;
    }

    message PersonWithMoreRequiredFields {
      string first_name = 1;
      optional string nick_name = 2;
      int32 birth_year = 3;
      Employer current_employer = 4;
      repeated Employer previous_employers = 5;
      map<string, Employer> favorite_employers_by_name = 6;
      map<string, string> metadata = 7;
    }

    message EmployerWithCustomJsonNames {
      optional string name = 1 [json_name = "NAME"];
    }

    message PersonWithCustomJsonNames {
      string first_name = 1 [json_name = "FIRST_NAME"];
      optional string nick_name = 2 [json_name = "NICK_NAME"];
      optional int32 birth_year = 3 [json_name = "BIRTH_YEAR"];
      optional EmployerWithCustomJsonNames current_employer = 4 [json_name = "CURRENT_EMPLOYER"];
      repeated EmployerWithCustomJsonNames previous_employers = 5 [json_name = "PREVIOUS_EMPLOYERS"];
      map<string, EmployerWithCustomJsonNames> favorite_employers_by_name = 6 [json_name = "FAVORITE_EMPLOYERS_BY_NAME"];
      map<string, string> metadata = 7 [json_name = "METADATA"];
    }
  PROTO

  class_eval ProtoBoeuf::CodeGen.new(unit).to_ruby

  def test_to_h_with_all_fields
    jane = Person.new(
      first_name: "Jane",
      nick_name: "J-dog",
      birth_year: 1984,
      current_employer: Employer.new(name: "Business Inc."),
      previous_employers: [Employer.new(name: "Funny Business LLC")],
      favorite_employers_by_name: {
        "Business Inc." => Employer.new(name: "Business Inc."),
      },
      metadata: { "favorite_color" => "blue" },
    )

    assert_equal(
      {
        first_name: "Jane",
        nick_name: "J-dog",
        birth_year: 1984,
        current_employer: { name: "Business Inc." },
        previous_employers: [{ name: "Funny Business LLC" }],
        favorite_employers_by_name: { "Business Inc." => { name: "Business Inc." } },
        metadata: { "favorite_color" => "blue" },
      },
      jane.to_h,
    )
  end

  def test_to_h_with_missing_fields
    nobody = Person.new

    assert_equal(
      {
        first_name: "",
        nick_name: "",
        birth_year: 0,
        current_employer: {},
        previous_employers: [],
        favorite_employers_by_name: {},
        metadata: {},
      },
      nobody.to_h,
    )
  end

  def test_as_json_with_all_fields
    jane = Person.new(
      first_name: "Jane",
      nick_name: "J-dog",
      birth_year: 1984,
      current_employer: Employer.new(name: "Business Inc."),
      previous_employers: [Employer.new(name: "Funny Business LLC")],
      favorite_employers_by_name: {
        "Business Inc." => Employer.new(name: "Business Inc."),
      },
      metadata: { "favorite_color" => "blue" },
    )

    assert_equal(
      {
        "firstName" => "Jane",
        "nickName" => "J-dog",
        "birthYear" => 1984,
        "currentEmployer" => { "name" => "Business Inc." },
        "previousEmployers" => [{ "name" => "Funny Business LLC" }],
        "favoriteEmployersByName" => { "Business Inc." => { "name" => "Business Inc." } },
        "metadata" => { "favorite_color" => "blue" },
      },
      jane.as_json,
    )
  end

  def test_as_json_with_missing_fields
    nobody = Person.new

    assert_equal(
      {
        "firstName" => "",
        "nickName" => "",
        "birthYear" => 0,
        "currentEmployer" => {},
        "previousEmployers" => [],
        "favoriteEmployersByName" => {},
        "metadata" => {},
      },
      nobody.as_json,
    )
  end

  def test_as_json_compact_compact_with_all_fields
    jane = Person.new(
      first_name: "Jane",
      nick_name: "J-dog",
      birth_year: 1984,
      current_employer: Employer.new(name: "Business Inc."),
      previous_employers: [Employer.new(name: "Funny Business LLC")],
      favorite_employers_by_name: {
        "Business Inc." => Employer.new(name: "Business Inc."),
      },
      metadata: { "favorite_color" => "blue" },
    )

    assert_equal(
      {
        "firstName" => "Jane",
        "nickName" => "J-dog",
        "birthYear" => 1984,
        "currentEmployer" => { "name" => "Business Inc." },
        "previousEmployers" => [{ "name" => "Funny Business LLC" }],
        "favoriteEmployersByName" => { "Business Inc." => { "name" => "Business Inc." } },
        "metadata" => { "favorite_color" => "blue" },
      },
      jane.as_json(compact: true),
    )
  end

  def test_as_json_compact_with_missing_fields
    nobody = Person.new

    # The compact option will omit empty or non-default values for fields marked as optional.  Non-optional fields with
    # default or empty values will still appear in the resulting Hash.

    assert_equal(
      {
        "firstName" => "",
      },
      nobody.as_json(compact: true),
    )

    another_nobody = PersonWithMoreRequiredFields.new

    assert_equal(
      {
        "firstName" => "",
        "birthYear" => 0,
        "currentEmployer" => {},
      },
      another_nobody.as_json(compact: true),
    )
  end

  def test_as_json_with_json_value_overrides
    jane = PersonWithCustomJsonNames.new(
      first_name: "Jane",
      nick_name: "J-dog",
      birth_year: 1984,
      current_employer: EmployerWithCustomJsonNames.new(name: "Business Inc."),
      previous_employers: [EmployerWithCustomJsonNames.new(name: "Funny Business LLC")],
      favorite_employers_by_name: {
        "Business Inc." => EmployerWithCustomJsonNames.new(name: "Business Inc."),
      },
      metadata: { "favorite_color" => "blue" },
    )

    # Confirm that #to_h isn't affected by json_value overrides
    assert_equal(
      {
        first_name: "Jane",
        nick_name: "J-dog",
        birth_year: 1984,
        current_employer: { name: "Business Inc." },
        previous_employers: [{ name: "Funny Business LLC" }],
        favorite_employers_by_name: { "Business Inc." => { name: "Business Inc." } },
        metadata: { "favorite_color" => "blue" },
      },
      jane.to_h,
    )

    assert_equal(
      {
        "FIRST_NAME" => "Jane",
        "NICK_NAME" => "J-dog",
        "BIRTH_YEAR" => 1984,
        "CURRENT_EMPLOYER" => { "NAME" => "Business Inc." },
        "PREVIOUS_EMPLOYERS" => [{ "NAME" => "Funny Business LLC" }],
        "FAVORITE_EMPLOYERS_BY_NAME" => { "Business Inc." => { "NAME" => "Business Inc." } },
        "METADATA" => { "favorite_color" => "blue" },
      },
      jane.as_json,
    )
  end

  def test_to_json
    jane = Person.new(
      first_name: "Jane",
      nick_name: "J-dog",
      birth_year: 1984,
      current_employer: Employer.new(name: "Business Inc."),
      previous_employers: [Employer.new(name: "Funny Business LLC")],
      favorite_employers_by_name: {
        "Business Inc." => Employer.new(name: "Business Inc."),
      },
      metadata: { "favorite_color" => "blue" },
    )

    assert_equal(
      {
        "firstName" => "Jane",
        "nickName" => "J-dog",
        "birthYear" => 1984,
        "currentEmployer" => { "name" => "Business Inc." },
        "previousEmployers" => [{ "name" => "Funny Business LLC" }],
        "favoriteEmployersByName" => { "Business Inc." => { "name" => "Business Inc." } },
        "metadata" => { "favorite_color" => "blue" },
      },
      JSON.parse(jane.to_json),
    )

    nobody = Person.new

    assert_equal(
      {
        "firstName" => "",
      },
      JSON.parse(nobody.to_json(compact: true)),
    )

    joe = PersonWithCustomJsonNames.new(
      first_name: "Joe",
      nick_name: "J-dog",
      birth_year: 1984,
      current_employer: EmployerWithCustomJsonNames.new(name: "Business Inc."),
      previous_employers: [EmployerWithCustomJsonNames.new(name: "Funny Business LLC")],
      favorite_employers_by_name: {
        "Business Inc." => EmployerWithCustomJsonNames.new(name: "Business Inc."),
      },
      metadata: { "favorite_color" => "blue" },
    )

    assert_equal(
      {
        "FIRST_NAME" => "Joe",
        "NICK_NAME" => "J-dog",
        "BIRTH_YEAR" => 1984,
        "CURRENT_EMPLOYER" => { "NAME" => "Business Inc." },
        "PREVIOUS_EMPLOYERS" => [{ "NAME" => "Funny Business LLC" }],
        "FAVORITE_EMPLOYERS_BY_NAME" => { "Business Inc." => { "NAME" => "Business Inc." } },
        "METADATA" => { "favorite_color" => "blue" },
      },
      JSON.parse(joe.to_json),
    )
  end
end
