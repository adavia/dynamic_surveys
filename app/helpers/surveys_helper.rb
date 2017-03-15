module SurveysHelper
  def survey_completion_percentage(survey)
    percentage = (Float(@survey.submissions.complete) / @survey.submissions.size * 100)
    if !percentage.nan?
      "(#{percentage.ceil}%)"
    end
  end

  def rating_avg(arr)
    avg = arr.inject{ |sum, el| sum + el }.to_f / arr.size
    if !avg.nan?
      avg
    else
      "_"
    end
  end
end
