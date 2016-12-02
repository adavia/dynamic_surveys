class Survey < ApplicationRecord
  belongs_to :customer
  has_many :questions, dependent: :destroy

  validates :name, presence: true, length: { minimum: 4, maximum: 250 }

  accepts_nested_attributes_for :questions, allow_destroy: true
end
