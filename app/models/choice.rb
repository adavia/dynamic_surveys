class Choice < ApplicationRecord
  belongs_to :question
  has_and_belongs_to_many :answers, dependent: :destroy

  validates :title, presence: true, length: { maximum: 250 }
end
