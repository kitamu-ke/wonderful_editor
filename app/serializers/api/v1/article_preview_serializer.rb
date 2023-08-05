class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  attributes %i[id body title updated_at]
  belongs_to :user, serializer: Api::V1::UserSerializer
end
