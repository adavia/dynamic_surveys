class AnswerDate < ApplicationRecord
  belongs_to :answer

  validates :response, presence: true
  validates :answer, presence: true
end
