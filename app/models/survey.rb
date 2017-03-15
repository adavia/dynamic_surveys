class Survey < ApplicationRecord
  belongs_to :customer, counter_cache: true
  has_many :questions, dependent: :destroy
  has_many :alerts, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_many :submission_views

  validates :name, presence: true, length: { minimum: 4, maximum: 250 }
  validates :avatar, file_size: { less_than_or_equal_to: 2.gigabytes },
                     file_content_type: { allow: ['image/jpeg', 'image/png'] }
  validates_associated :questions

  accepts_nested_attributes_for :questions, allow_destroy: true

  scope :date_surveys,       -> { group("DATE(created_at)").count }
  scope :excluding_archived, -> { where(archived_at: nil).order(created_at: :desc) }

  mount_uploader :avatar, ImageUploader

  self.per_page = 12

  # Archive survey
  def archive
    self.update_column :archived_at, Time.now
  end

  # Search survey
  def self.search(search)
    where("surveys.name ILIKE ?", "%#{search}%").or(where("surveys.description ILIKE ?", "%#{search}%"))
  end
end
