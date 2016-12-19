class ChoiceAnswer < ApplicationRecord
  belongs_to :choice
  belongs_to :answer
  belongs_to :answer_multiple

  validates :choice, presence: true
  validates :answer, presence: true
end
