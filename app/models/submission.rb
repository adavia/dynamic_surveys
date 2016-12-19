class Submission < ApplicationRecord
  belongs_to :survey
  belongs_to :user
  has_many :questions, through: :survey
  has_many :answers, inverse_of: :submission, dependent: :destroy

  accepts_nested_attributes_for :answers, reject_if: :all_blank

  validates :survey, presence: true
  validates :user, presence: true

  validate :must_complete_all_answers

  def must_complete_all_answers
    if questions.any? && answers.empty?
      errors.add(:base, "You must complete all answers before submitting the survey!")
    end
  end
end
