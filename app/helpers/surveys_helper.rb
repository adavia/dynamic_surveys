module SurveysHelper
  def survey_completion_percentage(survey)
    percentage = (Float(@survey.submissions.complete) / @survey.submissions.size * 100)
    if !percentage.nan?
      "(#{percentage.ceil}%)"
    end
  end
end
