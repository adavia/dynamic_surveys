class SubmissionNotifierMailer < ApplicationMailer
  def notifier(answer, alert)
    @answer   = answer
    @alert    = alert
    mail(to: @alert.to, subject: @alert.subject)
  end
end
