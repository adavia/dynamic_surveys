class Alert < ApplicationRecord
  belongs_to :survey
  has_one :alert_filter, dependent: :destroy

  validates :from, presence: true
  validates :to, presence: true
  validates :subject, presence: true

  accepts_nested_attributes_for :alert_filter

  self.per_page = 16
end
