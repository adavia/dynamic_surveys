class SubmissionNotifierMailer < ApplicationMailer
  def notifier(alert, notifications)
    @alert = alert
    @notifications = notifications
    mail(to: @alert.to, subject: @alert.subject)
  end
end
