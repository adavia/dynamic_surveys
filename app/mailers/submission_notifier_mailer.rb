class SubmissionNotifierMailer < ApplicationMailer
  def notifier(response, alert)
    @response = response
    @alert    = alert
    mail(from: @alert.from, to: @alert.to, subject: @alert.subject)
  end
end
