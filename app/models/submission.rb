class Submission < ApplicationRecord
  belongs_to :survey, counter_cache: true
  belongs_to :sender, polymorphic: true
  has_many :questions, through: :survey
  has_many :answers, inverse_of: :submission, dependent: :destroy

  # Rails.logger.debug attributes.inspect

  accepts_nested_attributes_for :answers, reject_if: :reject_answer_type
  validates :survey, presence: true
  validates :sender, presence: true

  self.per_page = 15

  after_create :mark_as_completed

  # Statistics

  scope :complete,   -> { where(complete: true).size }
  scope :incomplete, -> { where(complete: false).size }

  def reject_answer_type(attributes)
    rates = attributes[:answer_raitings_attributes]
    if !rates.nil?
      rates.delete_if { |k, v| v["response"].empty? }
    end
    (rates && (rates.nil? || rates == {}))  || (attributes[:answer_open_attributes] && attributes[:answer_open_attributes][:response].blank?) || (attributes[:answer_date_attributes] && attributes[:answer_date_attributes][:response].blank?) || (attributes[:answer_image_attributes] && attributes[:answer_image_attributes][:image_id].blank?) || (attributes[:choice_answer_attributes] && attributes[:choice_answer_attributes][:choice_id].blank?) || (attributes[:answer_multiple_attributes] && attributes[:answer_multiple_attributes][:choice_ids] == [""])
  end

  # Filters

  def self.created_before(date)
    where("submissions.created_at <= ?", Date.parse(date))
  end

  def self.created_after(date)
    where("submissions.created_at >= ?", Date.parse(date))
  end

  def self.question_id(id)
    joins(:questions).where("questions.id": id)
  end

  def self.choice_id(id)
    joins(answers: :choice_answer).where("choice_answers.choice_id": id)
  end

  def self.choice_multiple_ids(ids)
    joins(answers: {answer_multiple: :choice_answers}).where("choice_answers.choice_id": ids).distinct
  end

  def self.image_id(id)
    joins(answers: :answer_image).where("answer_images.image_id": id)
  end

  def self.rating_id(option)
    joins(answers: {answer_raitings: :raiting}).where("raitings.id": option)
  end

  def self.rate(response)
    joins(answers: {answer_raitings: :raiting}).where("answer_raitings.response": response)
  end

  private

  def mark_as_completed
    if answers.size == questions.size
      update! complete: true
    end
  end
end
