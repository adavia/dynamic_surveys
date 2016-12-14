class Answer < ApplicationRecord
  belongs_to :submission
  belongs_to :question

  has_one :answer_date, dependent: :destroy
  has_one :answer_raiting, dependent: :destroy
  has_one :answer_open, dependent: :destroy
  has_one :answer_multiple, dependent: :destroy
  has_one :answer_image, dependent: :destroy
  has_one :choice_answer, dependent: :destroy

  #has_many :option_answers, dependent: :destroy

  accepts_nested_attributes_for :answer_open
  accepts_nested_attributes_for :answer_date
  accepts_nested_attributes_for :answer_raiting
  accepts_nested_attributes_for :answer_multiple
  accepts_nested_attributes_for :answer_image
  accepts_nested_attributes_for :choice_answer
  #accepts_nested_attributes_for :option_answers

  validates :question_id, presence: true

  scope :raiting_average,         -> { joins(:answer_raiting).average("answer_raitings.response")}
  scope :image_counter,           -> { joins(:answer_image).group("answer_images.id").count }
  scope :choice_counter,          -> { joins(choice_answer: :choice).group("choices.title").count }
  scope :multiple_choice_counter, -> { joins(answer_multiple: [:choices]).group("choices.title").count }
end
