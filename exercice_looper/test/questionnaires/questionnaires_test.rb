# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../models/questionnaire"

class QuestionnaireTest < Minitest::Test
  def test_declares_its_table_primary_key_and_columns
    assert_equal "questionnaires", Questionnaire::TABLE_NAME
    assert_equal :questionnaire_id, Questionnaire::PRIMARY_KEY
    assert_equal %i[questionnaire_id title status], Questionnaire::COLUMNS
  end

  def test_new_questionnaire_starts_in_editing_without_an_id
    questionnaire = Questionnaire.new(title: "Ruby")

    assert_nil questionnaire.questionnaire_id
    assert_equal "Ruby", questionnaire.title
    assert_equal "editing", questionnaire.status
  end

  def test_existing_questionnaire_keeps_its_id_and_status
    questionnaire = Questionnaire.new(questionnaire_id: 42, title: "Ruby", status: "closed")

    assert_equal 42, questionnaire.questionnaire_id
    assert_equal "closed", questionnaire.status
  end
end
