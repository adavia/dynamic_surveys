class SurveySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :avatar, :questions_count, :created_at

  belongs_to :customer
  has_many :questions
end
