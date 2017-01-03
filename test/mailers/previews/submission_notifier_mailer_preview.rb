# Preview all emails at http://localhost:3000/rails/mailers/submission_notifier_mailer
class SubmissionNotifierMailerPreview < ActionMailer::Preview
  def rating_notifier
    SubmissionNotifierMailer.rating_notifier(Submission.last)
  end
end
