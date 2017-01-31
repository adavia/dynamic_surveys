class AnswerImage < ApplicationRecord
  belongs_to :image
  belongs_to :answer
end
