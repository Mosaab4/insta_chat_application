class CreateChatJob
  include Sidekiq::Job

  def perform(application_id,application_token)
    chat_number = 0

    last_chat_entry = Chat.where(application_id: application_id).order('id DESC').first

    unless last_chat_entry.nil?
      chat_number = last_chat_entry.chat_number
    end

    Chat.create(application_id: application_id, chat_number: chat_number + 1)

    $redis.del(Application.chats_redis_key(application_token))
  end
end
