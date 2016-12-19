class AnswerImage < ApplicationRecord
  belongs_to :image
  belongs_to :answer

  validates :image, presence: { message: "You must select an image from the list" }
  validates :answer, presence: true
end
