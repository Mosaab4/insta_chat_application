class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages

  def self.redis_key(chat_number,application_token)
    "chat_data_" + chat_number.to_s + '_' + application_token
  end

  def self.messages_redis_key(chat_number ,application_token)
    "chat_messages_" + chat_number.to_s + '_' + application_token
  end
end
