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

  def self.filter_submissions(submissions, params)
    if params[:created_before].present?
      submissions = submissions.where("submissions.created_at <= ?", Date.parse(params[:created_before]))
    end
    if params[:created_after].present?
      submissions = submissions.where("submissions.created_at >= ?", Date.parse(params[:created_after]))
    end
    if params[:question_id].present?
      submissions = submissions.joins(:questions).where("questions.id": params[:question_id])
    end
    if params[:choice_id].present?
      submissions = submissions.joins(answers: :choice_answer).where("choice_answers.choice_id": params[:choice_id])
    end
    if params[:choice_multiple_ids].present?
      submissions = submissions.joins(answers: {answer_multiple: :choice_answers}).where("choice_answers.choice_id": params[:choice_multiple_ids]).distinct
    end
    if params[:image_id].present?
      submissions = submissions.joins(answers: :answer_image).where("answer_images.image_id": params[:image_id])
    end
    if params[:rating_id].present? && params[:rate].present?
      submissions = submissions.joins(answers: :answer_raitings).where("answer_raitings.raiting_id": params[:rating_id]).where("answer_raitings.response": params[:rate])
    end
    submissions
  end

  def notifications_lookup(filters, answers)
    filters.flat_map do |f|
      answers.select do |a|
        a.question == f.question
      end.select do |a|
        case a.question.question_type
        when "image"
          a.answer_image.image_id == f.answer.to_i
        when "single", "list"
          a.choice_answer.choice_id == f.answer.to_i
        when "multiple"
          !(f.answer.split(",").map(&:to_i) & a.answer_multiple.choices.map(&:id)).empty?
        when "rating"
          verify_condition(f, a).any?
        else
          true
        end
      end
    end
  end

  def verify_condition(filter, a)
    a.answer_raitings.map do |r|
      r.raiting == filter.raiting && filter.answer.split(",").map(&:to_i).include?(r.response)
    end
  end

  private

  def mark_as_completed
    if answers.size == questions.size
      update! complete: true
    end
  end
end
