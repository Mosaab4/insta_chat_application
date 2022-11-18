class Application < ApplicationRecord
  validates_uniqueness_of :name

  has_many :chats
end
