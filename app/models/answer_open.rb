class AnswerOpen < ApplicationRecord
  belongs_to :answer
  validates :answer, presence: true
end
