class Choice < ApplicationRecord
  belongs_to :question
  belongs_to :choice_field, polymorphic: true

  validates :title, presence: true, length: { maximum: 250 }
end
