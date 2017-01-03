class SubmissionNotifierMailer < ApplicationMailer
  def rating_notifier(submission)
    @submission = submission
    mail(to: "andresi.davia@gmail.com",
      subject: "Rating notification - #{@submission.survey.name}")
  end
end
