class Raiting < ApplicationRecord
  belongs_to :question

  validates :name, presence: true
end
