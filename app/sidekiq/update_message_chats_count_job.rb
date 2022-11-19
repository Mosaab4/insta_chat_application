class UpdateMessageChatsCountJob
  include Sidekiq::Job

  def perform(chat_id)
    count = Message.where(chat_id: chat_id).count
    Chat.where(id: chat_id).update(messages_count: count)
  end
end
