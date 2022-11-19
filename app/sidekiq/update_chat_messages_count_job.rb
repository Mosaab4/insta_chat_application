class UpdateChatMessagesCountJob
  include Sidekiq::Job

  def perform(chat_id)
    count = Message.where(chat_id: chat_id).count
    Chat.where(id: chat_id).update(messages_count: count)

    chat = Chat.find(chat_id)
    $redis.set(Chat.redis_key(chat.id), chat.to_json)

    application = chat.application
    chats = application.chats.to_json
    $redis.set(Application.chats_redis_key(application.token), chats)

    messages = Message.where(chat_id: chat_id).to_json
    $redis.set(Chat.messages_redis_key(chat_id), messages)
  end
end
