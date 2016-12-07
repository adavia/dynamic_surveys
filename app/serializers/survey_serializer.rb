class SurveySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :created_at

  belongs_to :customer
  has_many :questions
end
