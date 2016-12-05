class Option < ApplicationRecord
  belongs_to :question

  validates :title, presence: true, length: { maximum: 250 }
end
