class AnswerMultiple < ApplicationRecord
  belongs_to :answer

  has_many :choices, through: :choice_answers
  has_many :choice_answers

  validates :choices, presence: true
end
