class Submission < ApplicationRecord
  belongs_to :survey
  belongs_to :user
  has_many :questions, through: :survey
  has_many :answers, inverse_of: :submission, dependent: :destroy

  accepts_nested_attributes_for :answers, reject_if: :all_blank

  validates :survey, presence: true
  validates :user, presence: true

  validate :must_complete_all_answers

  self.per_page = 15

  def must_complete_all_answers
    if questions.any? && answers.empty?
      errors.add(:base, "You must complete all answers before submitting the survey!")
    end
  end

  # Search submissions
  # def self.date_filter(from, to)
    # where(created_at: from..to)
  # end

  def self.created_before(date)
    where("submissions.created_at < ?", date)
  end

  def self.created_after(date)
    where("submissions.created_at > ?", date)
  end

  def self.question_id(id)
    joins(:questions).where("questions.id": id)
  end

  def self.question_type(type)
    joins(:questions).where("questions.question_type": type)
  end
end
