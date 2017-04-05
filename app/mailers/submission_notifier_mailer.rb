class SubmissionNotifierMailer < ApplicationMailer
  def notifier(alert)
    @alert = alert
    mail(to: @alert.keys[0].to, subject: @alert.keys[0].subject)
  end
end
