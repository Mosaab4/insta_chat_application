class ApplicationSerializer < ActiveModel::Serializer
  attributes :name, :token

  has_many :chats
end