class Survey < ApplicationRecord
  belongs_to :customer, counter_cache: true
  has_many :questions, dependent: :destroy
  has_many :submissions, dependent: :destroy

  validates :name, presence: true, length: { minimum: 4, maximum: 250 }
  validates :questions,
    presence: { message: "You must add at least one question to the survey." }
  validates_associated :questions

  accepts_nested_attributes_for :questions, allow_destroy: true

  scope :date_surveys,       -> { group("DATE(created_at)").count }
  scope :excluding_archived, -> { where(archived_at: nil) }

  mount_uploader :avatar, ImageUploader

  # Archive survey
  def archive
    self.update_column :archived_at, Time.now
  end
end
