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
  scope :open_responses,          -> (question) { includes(:submission, :answer_open).where(question_id: question).order("answer_opens.created_at desc") }
  scope :date_responses,          -> (question) { includes(:submission, :answer_date).where(question_id: question).order("answer_dates.created_at desc") }
  scope :rated_responses,         -> (question) { joins(answer_raitings: :raiting).where(question_id: question).select("raitings.name as rate, count(*) as count, avg(answer_raitings.response) as avg").group("rate").order("count DESC") }
  scope :image_responses,         -> (question) { joins(answer_image: :image).where(question_id: question).group("images.name").count }
  scope :choice_responses,        -> (question) { joins(choice_answer: :choice).where(question_id: question).group("choices.title").count }
  scope :multiple_responses,      -> (question) { joins(answer_multiple: [:choices]).where(question_id: question).group("choices.title").count }

  self.per_page = 10

  def self.collect_submissions(answers)
    joins(:submission).where("submissions.id": answers.map(&:submission_id).uniq)
  end

  # Filters

  def self.filter_answers(answers, params)
    if params[:created_before].present?
      answers = answers.where("answers.created_at <= ?", Date.parse(params[:created_before]))
      answers = self.collect_submissions(answers)
    end
    if params[:created_after].present?
      answers = answers.where("answers.created_at >= ?", Date.parse(params[:created_after]))
      answers = self.collect_submissions(answers)
    end
    if params[:question_id].present?
      answers = answers.joins(:question).where("questions.id": params[:question_id])
      answers = self.collect_submissions(answers)
    end
    if params[:choice_id].present?
      answers = answers.joins(:choice_answer).where("choice_answers.choice_id": params[:choice_id])
      answers = self.collect_submissions(answers)
    end
    if params[:choice_multiple_ids].present?
      answers = answers.joins(answer_multiple: :choice_answers).where("choice_answers.choice_id": params[:choice_multiple_ids]).distinct
      answers = self.collect_submissions(answers)
    end
    if params[:image_id].present?
      answers = answers.joins(:answer_image).where("answer_images.image_id": params[:image_id])
      answers = self.collect_submissions(answers)
    end
    if params[:rating_id].present? && params[:rate].present?
      answers = answers.joins(:answer_raitings).where("answer_raitings.raiting_id": params[:rating_id]).where("answer_raitings.response": params[:rate])
      answers = self.collect_submissions(answers)
    end
    answers
  end
end
