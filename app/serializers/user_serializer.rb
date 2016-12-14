class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :last_name, :email, :image, :api_key
end
