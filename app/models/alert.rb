class Alert < ApplicationRecord
  belongs_to :survey
  has_one :alert_filter, dependent: :destroy

  validates :from, presence: true
  validates :to, presence: true
  validates :subject, presence: true

  validate :check_email_addresses

  accepts_nested_attributes_for :alert_filter

  self.per_page = 16

  def check_email_addresses
    to.split(/,\s*/).each do |email|
      unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
        errors.add(:to,
          "#{I18n.t("app.survey.notifications.filters.invalid_emails")} #{email}")
      end
    end
  end
end
