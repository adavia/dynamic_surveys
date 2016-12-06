class AnswerOpen < ApplicationRecord
  belongs_to :answer

  validates :response, presence: true
end
