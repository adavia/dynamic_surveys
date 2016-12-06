class OptionAnswer < ApplicationRecord
  belongs_to :answer
  belongs_to :option
  belongs_to :choice

  validates :choice, presence: true
  validates :option, presence: true
end
