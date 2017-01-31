class AnswerRaiting < ApplicationRecord
  belongs_to :answer

  RAITING = {
    "5": "star_5",
    "4": "star_4",
    "3": "star_3",
    "2": "star_2",
    "1": "star_1"
  }
end
