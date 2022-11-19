class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages

  def self.redis_key(id)
    "chat_data_" + id.to_s
  end

  def self.messages_redis_key(id)
    "chat_messages_" + id.to_s
  end
end
