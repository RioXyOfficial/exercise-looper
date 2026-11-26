# frozen_string_literal: true

class QuestionType

  TABLE_NAME = "question_types"
  PRIMARY_KEY = :question_type_id
  COLUMNS = [:question_type_id, :description].freeze

  attr_accessor :question_type_id, :description

  def initialize(question_type_id:nil, description:)
    @question_type_id = question_type_id
    @description = description
  end

end
