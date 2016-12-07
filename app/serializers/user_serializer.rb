class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :last_name, :email, :api_key
end
