class Question < ApplicationRecord
  belongs_to :survey, counter_cache: true
  belongs_to :question_type

  has_many :answers, dependent: :destroy
  has_many :choices, dependent: :destroy
  has_many :options, dependent: :destroy
  has_many :images, dependent: :destroy

  validates :question_type, presence: true
  validates :title, presence: true, length: { minimum: 4, maximum: 250 }
  validate :must_perform_action

  accepts_nested_attributes_for :choices, allow_destroy: true
  accepts_nested_attributes_for :options, allow_destroy: true
  accepts_nested_attributes_for :images, allow_destroy: true

  default_scope  { order(:position) }
  scope :group_types, -> { joins(:question_type).group("question_types.name").count }

  #scope :answer_multiple, -> { joins(answers: {answer_multiple: [:choices]}).group("choices.title").count }

  private

  def must_perform_action
    if question_type_id == 5 && !images.reject(&:marked_for_destruction?).any?
      errors.add(:question_type_id, "You must upload an image!")
    elsif question_type_id == 5 && choices.reject(&:marked_for_destruction?).any?
      errors.add(:question_type_id, "This is not allowed!")
    elsif [2, 3, 7].include?(question_type_id) && !choices.reject(&:marked_for_destruction?).any?
      errors.add(:question_type_id, "You must add a possible choice!")
    elsif [2, 3, 7].include?(question_type_id) && images.reject(&:marked_for_destruction?).any?
      errors.add(:question_type_id, "This is not allowed!")
    #elsif question_type_id == 7 && !options.reject(&:marked_for_destruction?).any?
      #errors.add(:question_type_id, "You must add a possible option!")
    #elsif question_type_id == 7 && images.reject(&:marked_for_destruction?).any?
      #errors.add(:question_type_id, "This is not allowed!")
    elsif [1, 4, 6].include?(question_type_id) && (choices.reject(&:marked_for_destruction?).any? || images.reject(&:marked_for_destruction?).any?)
      errors.add(:question_type_id, "You must select a valid question type!")
    end
  end
end
