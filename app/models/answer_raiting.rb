class AnswerRaiting < ApplicationRecord
  belongs_to :answer

  validates :response, presence: { message: :select_rate }
  validates :response, inclusion: { in: 1..5 }

  RAITING = {
    "5": "star_5",
    "4": "star_4",
    "3": "star_3",
    "2": "star_2",
    "1": "star_1"
  }
end
