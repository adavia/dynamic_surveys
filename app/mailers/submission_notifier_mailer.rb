class SubmissionNotifierMailer < ApplicationMailer
  def rating_notifier(submission)
    @submission = submission
    mail(to: "hugo@socialastronauts.com",
      subject: "Rating notification - #{@submission.survey.name}")
  end
end
