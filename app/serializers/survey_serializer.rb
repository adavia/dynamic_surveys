class SurveySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :avatar, :questions_count, :user_image, :created_at

  belongs_to :customer
  has_many :questions

  def user_image
    current_user.image
  end
end
