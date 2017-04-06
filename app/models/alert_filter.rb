class AlertFilter < ApplicationRecord
  belongs_to :question
  belongs_to :alert
  belongs_to :raiting

  validates :question_id, presence: true

  default_scope  { order(id: :asc) }

  before_save do
    self.answer.gsub!(/[\[\]\"]/, "") if attribute_present?("answer")
  end

  before_update do
    if self.question.raitings.empty?
      self.raiting_id = nil
    end
  end
end
