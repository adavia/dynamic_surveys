class ChoiceAnswer < ApplicationRecord
  belongs_to :choice
  belongs_to :answer

  validates :choice, presence: true
end
