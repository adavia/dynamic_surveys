class AlertFilter < ApplicationRecord
  belongs_to :question
  belongs_to :alert

  before_save do
    self.answer.gsub!(/[\[\]\"]/, "") if attribute_present?("answer")
  end
end
