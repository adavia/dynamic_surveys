class SurveySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :question_counter, :created_at

  belongs_to :customer
  has_many :questions

  def question_counter
    object.questions.size
  end
end
