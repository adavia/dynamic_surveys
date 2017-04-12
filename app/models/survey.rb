class Survey < ApplicationRecord
  belongs_to :customer, counter_cache: true
  has_many :questions, dependent: :destroy
  has_many :answers


  accepts_nested_attributes_for :questions, allow_destroy: true

  scope :date_surveys,       -> { group("DATE(created_at)").count }
  scope :excluding_archived, -> { where(archived_at: nil).order(created_at: :desc) }

  mount_uploader :avatar, ImageUploader

  self.per_page = 12


end
