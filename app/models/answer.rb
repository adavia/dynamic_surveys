class Answer < ApplicationRecord
  belongs_to :submission
  belongs_to :question, counter_cache: true

  has_one :answer_date, dependent: :destroy
  has_one :answer_open, dependent: :destroy
  has_one :answer_multiple, dependent: :destroy
  has_one :answer_image, dependent: :destroy
  has_one :choice_answer, dependent: :destroy
  has_many :answer_raitings, dependent: :destroy
  #has_many :option_answers, dependent: :destroy

  accepts_nested_attributes_for :answer_open
  accepts_nested_attributes_for :answer_date
  accepts_nested_attributes_for :answer_raitings
  accepts_nested_attributes_for :answer_multiple
  accepts_nested_attributes_for :answer_image
  accepts_nested_attributes_for :choice_answer
  #accepts_nested_attributes_for :option_answers

  validates :question, presence: true
  validates :submission, presence: true

  scope :rated_answers,           -> { joins(:answer_raitings) }
  scope :open_responses,          -> { includes(:answer_open).order("answer_opens.created_at desc").limit(10) }
  scope :date_responses,          -> { includes(:answer_date).order("answer_dates.created_at desc").limit(10) }
  scope :rating_average,          -> { joins(answer_raitings: :raiting).select("raitings.name as rate, count(*) as count, avg(answer_raitings.response) as avg").group("rate").order("count DESC") }
  scope :image_counter,           -> { joins(answer_image: :image).group("images.name").count }
  scope :choice_counter,          -> { joins(choice_answer: :choice).group("choices.title").count }
  scope :multiple_choice_counter, -> { joins(answer_multiple: [:choices]).group("choices.title").count }

  self.per_page = 15

  def self.created_before(date)
    where("answers.created_at < ?", Date.parse(date))
  end

  def self.created_after(date)
    where("answers.created_at > ?", Date.parse(date))
  end

  def self.rating_option(option)
    joins(answer_raitings: :raiting).where("raitings.id": option)
  end

  def self.rating_response(response)
    joins(answer_raitings: :raiting).where("answer_raitings.response": response)
  end
end
