class Choice < ApplicationRecord
  belongs_to :question

  has_many :answer_mutiples, through: :choice_answers
  has_many :choice_answers

  validates :title, presence: true, length: { maximum: 250 }
end
