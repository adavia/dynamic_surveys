class Customer < ApplicationRecord
  belongs_to :user
  has_many :surveys, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 250 }
end
