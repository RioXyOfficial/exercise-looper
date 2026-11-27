# frozen_string_literal: true

class Questionnaire
  TABLE_NAME = "questionnaires"
  PRIMARY_KEY = :questionnaire_id
  COLUMNS = [:questionnaire_id, :title, :status].freeze

  attr_accessor :questionnaire_id, :title, :status

  def initialize(title:, questionnaire_id: nil, status: "editing")
    @questionnaire_id = questionnaire_id
    @title = title
    @status = status
  end
end
