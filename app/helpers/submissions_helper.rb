module SubmissionsHelper
  def filtered_answers(ids)
    require 'will_paginate/array'

    if ids.any?
      Submission.includes(answers: [:answer_open, :answer_date])
        .find(ids).map do |s|
          s.answers.map { |a| a.answer_open }.compact
        end.flatten!(1)
    else
      false
    end
  end
end
