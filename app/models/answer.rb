class Answer < ApplicationRecord
  belongs_to :submission
  belongs_to :question

  has_one :answer_date, dependent: :destroy
  has_one :answer_raiting, dependent: :destroy
  has_one :answer_open, dependent: :destroy

  has_many :option_answers, dependent: :destroy
  has_many :choice_answers, dependent: :destroy

  accepts_nested_attributes_for :answer_open
  accepts_nested_attributes_for :answer_date
  accepts_nested_attributes_for :answer_raiting
  accepts_nested_attributes_for :choice_answers
  accepts_nested_attributes_for :option_answers

  validates :question, presence: true
end
