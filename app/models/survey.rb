class Survey < ApplicationRecord
  belongs_to :customer

  validates :name, presence: true, length: { minimum: 4, maximum: 250 }
end
