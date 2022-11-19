class Application < ApplicationRecord
  validates_uniqueness_of :name

  has_many :chats

  def self.redis_key(token)
    "application_data_" + token
  end

  def self.chats_redis_key(token)
    "application_chats_" + token
  end
end
