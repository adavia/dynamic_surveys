class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :question_type, :created_at

  has_many :choices
  has_many :images
end
