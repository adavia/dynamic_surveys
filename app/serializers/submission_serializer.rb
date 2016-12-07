class SubmissionSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :survey
  belongs_to :user
end
