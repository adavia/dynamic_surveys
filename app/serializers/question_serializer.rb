class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at

  has_many :choices
  has_many :images
end
