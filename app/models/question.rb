class Question < ApplicationRecord
  belongs_to :survey
  belongs_to :question_type

  has_many :choices, dependent: :destroy
  has_many :options, dependent: :destroy
  has_many :answers

  validates :question_type_id, presence: true
  validates :title, presence: true, length: { minimum: 4, maximum: 250 }

  accepts_nested_attributes_for :choices, allow_destroy: true
  accepts_nested_attributes_for :options, allow_destroy: true
end
