class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :last_name, :email, :password_digest, :api_key
end
