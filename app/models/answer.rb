class Answer < ApplicationRecord
  belongs_to :submission
  belongs_to :question
  has_and_belongs_to_many :choices
  has_many :option_answers, dependent: :destroy

  accepts_nested_attributes_for :option_answers

  # validates :answer_open, presence: true, allow_nil: true
  # validates :answer_date, presence: true, allow_nil: true
  # validates :answer_image, presence: true, allow_nil: true
  # validates :answer_single, presence: true, allow_nil: true
  # validates :answer_raiting, presence: true, allow_nil: true
  # validates :choices, presence: true, allow_nil: true
end
