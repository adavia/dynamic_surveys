class Answer < ApplicationRecord
  belongs_to :submission
  belongs_to :question, counter_cache: true
  belongs_to :survey

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

  #scope :rated_answers,          -> (question) { joins(:answer_raitings).where(question_id: question) }
  scope :open_responses,          -> (question, page) { includes(:submission, :answer_open).where(question_id: question).order("answer_opens.created_at desc").paginate(page: page) }
  scope :date_responses,          -> (question, page) { includes(:submission, :answer_date).where(question_id: question).order("answer_dates.created_at desc").paginate(page: page) }
  scope :rated_responses,         -> (question) { joins(answer_raitings: :raiting).where(question_id: question).select("raitings.name as rate, count(*) as count, avg(answer_raitings.response) as avg").group("rate").order("count DESC") }
  scope :image_responses,         -> (question) { joins(answer_image: :image).where(question_id: question).group("images.name").count }
  scope :choice_responses,        -> (question) { joins(choice_answer: :choice).where(question_id: question).group("choices.title").count }
  scope :multiple_responses,      -> (question) { joins(answer_multiple: [:choices]).where(question_id: question).group("choices.title").count }

  self.per_page = 10

  def self.collect_submissions(answers)
    joins(:submission).where("submissions.id": answers.map(&:submission_id).uniq)
  end

  # Filters

  def self.created_before(date)
    where("answers.created_at <= ?", Date.parse(date))
  end

  def self.created_after(date)
    where("answers.created_at >= ?", Date.parse(date))
  end

  def self.question_id(id)
    joins(:question).where("questions.id": id)
  end

  def self.choice_id(id)
    joins(:choice_answer).where("choice_answers.choice_id": id)
  end

  def self.choice_multiple_ids(ids)
    joins(answer_multiple: :choice_answers).where("choice_answers.choice_id": ids).distinct
  end

  def self.image_id(id)
    joins(:answer_image).where("answer_images.image_id": id)
  end

  def self.rate(option, response)
    joins(:answer_raitings).where("answer_raitings.raiting_id": option).where("answer_raitings.response": response)
  end
end
