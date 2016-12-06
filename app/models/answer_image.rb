class AnswerImage < ApplicationRecord
  belongs_to :image
  belongs_to :answer

  validates :image, presence: true
end
