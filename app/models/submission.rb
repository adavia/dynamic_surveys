class Submission < ApplicationRecord
  belongs_to :survey
  belongs_to :user
  has_many :questions, through: :survey
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers

  validates :survey_id, presence: true
  validates :user_id, presence: true

  validates_associated :answers
end
