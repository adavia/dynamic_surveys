class SubmissionSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :survey
  belongs_to :user

  has_many :questions
  has_many :answers
end
