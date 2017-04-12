class Question < ApplicationRecord
  belongs_to :survey, counter_cache: true

  has_many :answers, dependent: :destroy
  has_many :choices, dependent: :destroy
  has_many :raitings, dependent: :destroy
  #has_many :options, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :choices, allow_destroy: true


  def must_perform_action
    if question_type == "image" && !images.reject(&:marked_for_destruction?).any?
      errors.add(:question_type, :image_upload)
    elsif question_type == "image" && choices.reject(&:marked_for_destruction?).any?
      errors.add(:question_type, :not_allowed)
    elsif ["single", "multiple", "list"].include?(question_type) && !choices.reject(&:marked_for_destruction?).any?
      errors.add(:question_type, :add_choice)
    elsif ["single", "multiple", "list"].include?(question_type) && images.reject(&:marked_for_destruction?).any?
      errors.add(:question_type, :not_allowed)
    #elsif question_type == 7 && !options.reject(&:marked_for_destruction?).any?
      #errors.add(:question_type, "You must add a possible option!")
    #elsif question_type == 7 && images.reject(&:marked_for_destruction?).any?
      #errors.add(:question_type, "This is not allowed!")
    elsif ["open", "date", "rating", "description", "phone", "email"].include?(question_type) && (choices.reject(&:marked_for_destruction?).any? || images.reject(&:marked_for_destruction?).any?)
      errors.add(:question_type, :valid_question_type)
    end
  end
end
