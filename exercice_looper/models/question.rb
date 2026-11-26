# frozen_string_literal: true

class Question

  TABLE_NAME = "questions"
  PRIMARY_KEY = :question_id
  COLUMNS = [:question_id, :question_text, :questionnaire_id, :question_type_id].freeze

  attr_accessor :question_id, :question_text, :questionnaire_id, :question_type_id

  def initialize(question_text:, questionnaire_id:, question_type_id:, question_id: nil)
    @question_id = question_id
    @question_text = question_text
    @questionnaire_id = questionnaire_id
    @question_type_id = question_type_id
  end

end
