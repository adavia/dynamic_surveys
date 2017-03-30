module AnswersHelper
  def display_rates(arr)
    rates = arr.map do |a|
      if !a.response.nil?
        "#{a.raiting.name}: #{a.response}"
      end
    end
    rates
  end

  def display_answers(answers, questions)
    answers_by_question_id = answers.index_by(&:question_id)
    questions.map do |q|
      if answers_by_question_id[q.id] && answers_by_question_id[q.id].answer_open.present?
        answers_by_question_id[q.id].answer_open.response
      elsif answers_by_question_id[q.id] && answers_by_question_id[q.id].answer_date.present?
        answers_by_question_id[q.id].answer_date.response.strftime("%m/%d/%Y")
      elsif answers_by_question_id[q.id] && answers_by_question_id[q.id].answer_image.present?
        answers_by_question_id[q.id].answer_image.image.try(:name)
      elsif answers_by_question_id[q.id] && answers_by_question_id[q.id].choice_answer.present?
        answers_by_question_id[q.id].choice_answer.choice.try(:title)
      elsif answers_by_question_id[q.id] && answers_by_question_id[q.id].answer_multiple.present?
        answers_by_question_id[q.id].answer_multiple.choices.map(&:title).join(', ')
      elsif answers_by_question_id[q.id] && answers_by_question_id[q.id].answer_raitings.any?
        display_rates(answers_by_question_id[q.id].answer_raitings).join(" ")
      end
    end
  end
end
