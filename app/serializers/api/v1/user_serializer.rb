class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes %i[id name email]
end
