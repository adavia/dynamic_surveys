class SubmissionNotifierMailer < ApplicationMailer
  def rating_notifier(submission)
    @submission = submission
    mail(to: "hugo@socialastronauts.com",
      subject: "#{I18n.t("app.survey.email.subject")} - #{@submission.survey.name}")
  end
end
