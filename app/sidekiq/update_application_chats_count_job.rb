class UpdateApplicationChatsCountJob
  include Sidekiq::Job

  def perform(application_id)
    count = Chat.where(application_id: application_id).count
    Application.where(id: application_id).update(chats_count: count)
  end
end
