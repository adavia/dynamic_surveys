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
  scope :open_responses,          -> (params) { includes(:submission, :answer_open).merge(filters(params)).order("answer_opens.created_at desc").paginate(page: params[:page]) }
  scope :date_responses,          -> (params) { includes(:submission, :answer_date).merge(filters(params)).order("answer_dates.created_at desc").paginate(page: params[:page]) }
  scope :rating_average,          -> (params) { joins(answer_raitings: :raiting).merge(filters(params)).select("raitings.name as rate, count(*) as count, avg(answer_raitings.response) as avg").group("rate").order("count DESC") }
  scope :image_counter,           -> (params) { joins(answer_image: :image).merge(filters(params)).group("images.name").count }
  scope :choice_counter,          -> (params) { joins(choice_answer: :choice).merge(filters(params)).group("choices.title").count }
  scope :multiple_choice_counter, -> (params) { joins(answer_multiple: [:choices]).merge(filters(params)).group("choices.title").count }

  self.per_page = 10

  def self.filters(params)
    query = self.all
    if params[:created_before].present?
      query = query.where("answers.created_at <= ?", Date.parse(params[:created_before]))
    end
    if params[:created_after].present?
      query = query.where("answers.created_at >= ?", Date.parse(params[:created_after]))
    end
    if params[:question_id].present?
      query = query.joins(:question).where("questions.id": params[:question_id])
    end
    if params[:choice_id].present?
      query = query.joins(:choice_answer).where("choice_answers.choice_id": params[:choice_id])
    end
    if params[:image_id].present?
      query = query.joins(:answer_image).where("answer_images.image_id": params[:image_id])
    end
    if params[:choice_multiple_ids].present?
      query = query.joins(answer_multiple: :choice_answers).where("choice_answers.choice_id": params[:choice_multiple_ids]).distinct
    end
    if params[:rating_id].present?
      query = query.joins(answer_raitings: :raiting).where("raitings.id": params[:rating_id])
    end
    if params[:rate].present?
      query = query.joins(answer_raitings: :raiting).where("answer_raitings.response": params[:rate])
    end
    query
  end
end
