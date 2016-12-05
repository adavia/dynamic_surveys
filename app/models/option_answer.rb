class OptionAnswer < ApplicationRecord
  belongs_to :answer
  belongs_to :option
  belongs_to :choice
end
