class SurveySerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_one :customer
end
