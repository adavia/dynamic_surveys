class SubmissionNotifierMailer < ApplicationMailer
  def rating_notifier(submission)
    @submission = submission
    mail(to: "andresi.davia@gmail.com",
      subject: "Rating notification for survey #{@submission.survey.name}")
  end
end
