class Question < ApplicationRecord
  QUESTION_TYPES = {
    "Open":               "open",
    "Open Description":   "description",
    "Phone Number":       "phone",
    "Email Address":      "email",
    "Single Choice":      "single",
    "Single Choice List": "list",
    "Multiple Choice":    "multiple",
    "Date":               "date",
    "Images":             "image",
    "Rating":             "rating"
  }

  belongs_to :survey, counter_cache: true

  has_many :answers, dependent: :destroy
  has_many :choices, dependent: :destroy
  has_many :options, dependent: :destroy
  has_many :images, dependent: :destroy

  accepts_nested_attributes_for :choices, allow_destroy: true
  accepts_nested_attributes_for :options, allow_destroy: true
  accepts_nested_attributes_for :images, allow_destroy: true

  validates :question_type, presence: true
  validates :title, presence: true, length: { minimum: 4, maximum: 250 }
  validate :must_perform_action

  default_scope  { order(:position) }
  scope :group_types, -> { group("question_type").count }

  mount_uploader :info_image, ImageUploader

  #scope :answer_multiple, -> { joins(answers: {answer_multiple: [:choices]}).group("choices.title").count }

  after_save :clean_remove_info_image

  def changed?
    !!(super || remove_info_image)
  end

  def clean_remove_info_image
    self.remove_info_image = nil
  end

  private

  def must_perform_action
    if question_type == "image" && !images.reject(&:marked_for_destruction?).any?
      errors.add(:question_type, "You must upload an image!")
    elsif question_type == "image" && choices.reject(&:marked_for_destruction?).any?
      errors.add(:question_type, "This is not allowed!")
    elsif ["single", "multiple", "list"].include?(question_type) && !choices.reject(&:marked_for_destruction?).any?
      errors.add(:question_type, "You must add a possible choice!")
    elsif ["single", "multiple", "list"].include?(question_type) && images.reject(&:marked_for_destruction?).any?
      errors.add(:question_type, "This is not allowed!")
    #elsif question_type == 7 && !options.reject(&:marked_for_destruction?).any?
      #errors.add(:question_type, "You must add a possible option!")
    #elsif question_type == 7 && images.reject(&:marked_for_destruction?).any?
      #errors.add(:question_type, "This is not allowed!")
    elsif ["open", "date", "rating", "description", "phone", "email"].include?(question_type) && (choices.reject(&:marked_for_destruction?).any? || images.reject(&:marked_for_destruction?).any?)
      errors.add(:question_type, "You must select a valid question type!")
    end
  end
end
