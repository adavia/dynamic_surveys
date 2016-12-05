class SubmissionSerializer < ActiveModel::Serializer
  attributes :id
  has_one :survey
  has_one :user
end
