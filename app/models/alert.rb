class Alert < ApplicationRecord
  belongs_to :survey
  has_many :alert_filters, dependent: :destroy

  validates :from, presence: true
  validates :to, presence: true
  validates :subject, presence: true

  validate :check_email_addresses

  self.per_page = 16

  validates_format_of :from, with: /@/
  validates :subject, presence: true
  validates :body, presence: true

  def check_email_addresses
    to.split(/,\s*/).each do |email|
      unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
        errors.add(:to,
          "#{I18n.t("app.survey.notifications.filters.invalid_emails")} #{email}")
      end
    end
  end
end
