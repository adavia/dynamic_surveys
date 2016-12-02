class Customer < ApplicationRecord
  belongs_to :user
  has_many :surveys

  validates :name, presence: true, length: { minimum: 2, maximum: 250 }
end
