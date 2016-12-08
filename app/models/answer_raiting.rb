class AnswerRaiting < ApplicationRecord
  belongs_to :answer

  validates :response, presence: true
  validates :response, inclusion: { in: 1..5, message: "%{value} is not a valid rate" }

  RAITING = {
    "1": "star_1",
    "2": "star_2",
    "3": "star_3",
    "4": "star_4",
    "5": "star_5"
  }
end
