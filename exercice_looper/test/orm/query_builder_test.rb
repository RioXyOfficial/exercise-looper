# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../orm/query_builder"
class QueryBuilderTest < Minitest::Test

  def test_insert_builds_sql_and_parameters
    attributes = {
      question_text: "Hello MY bruda",
      questionnaire_id: 1,
      question_type_id: 2
    }

    expected = ["INSERT INTO questions (question_text, questionnaire_id, question_type_id) VALUES (?, ?, ?)", ["Hello MY bruda", 1, 2]]

    actual = QueryBuilder.insert("questions", attributes)

    puts "Expected  #{expected.inspect}"
    puts "Actual    #{actual.inspect}"

    assert_equal expected, actual
  end
end