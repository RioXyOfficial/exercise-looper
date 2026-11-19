
class AnswersService
  def initialize(answer_repository)
    @answer_repository = answer_repository
  end

  def create_submission(questions, answers)
    raise ArgumentError, "Questionnaire has no questions" if questions.empty?
    raise ArgumentError, "Invalid answers" unless answers.is_a?(Hash)
    @answer_repository.create_submission(questions, answers)
  end

  def find_answers(questionnaire_id, submission_id)
    @answer_repository.find_answers(questionnaire_id, submission_id)
  end

  def find_answers_by_questionnaire_id(questionnaire_id)
    answers_by_questionnaire_id = @answer_repository.find_answers_by_questionnaire(questionnaire_id)

    return nil if answers_by_questionnaire_id.empty?

    questions = {}
    attempts = {}

    answers_by_questionnaire_id.each do |row|
      question_id = row["question_id"]
      submission_id = row["submission_id"]

      # Store questions by ID to prevent duplicate columns.
      # Une question peut aparaitre plusieurs fois
      # example:
      # question_id	    question_text	      submission_id	    answer_text
      #   1	              Your name?	          10	              Pedro
      #   1	              Your name?	          11	              Luca
      #
      # DU coup pour eviter les doublouns on fait ça
      #
      if question_id
        questions[question_id] = {
          id: question_id,
          text: row["question_text"]
        }
      end

      # Pas de submission ID pas de essaie du cuop
      next if submission_id.nil?

      # On va donc regrouper les answers par submission_id
      if attempts[submission_id].nil?
        attempts[submission_id] = {
          id: submission_id,
          created_at: nil,
          answers: {}
        }
      end

      attempt = attempts[submission_id]

      attempt[:answers][question_id] = row["answer_text"]

      answer_date = row["created_at"]

      if answer_date
        if attempt[:created_at].nil? || answer_date < attempt[:created_at]
          attempt[:created_at] = answer_date
        end
      end
    end

    { title: answers_by_questionnaire_id.first["title"], questions: questions.values.sort_by { |question| question[:id] }, attempts: attempts.values }
  end

  def update_submission(submission_id, questions, answers)
    raise ArgumentError, "Invalid answers" unless answers.is_a?(Hash)
    @answer_repository.update_submission(submission_id, questions, answers)
  end
end
