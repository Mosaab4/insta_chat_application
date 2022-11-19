class UpdateApplicationChatsCountJob
  include Sidekiq::Job

  def perform(application_id)
    count = Chat.where(application_id: application_id).count
    Application.where(id: application_id).update(chats_count: count)

    application = Application.find(application_id)
    $redis.set(Application.redis_key(application.token), application.to_json)

    chats = Chat.where(application_id: application).to_json
    $redis.set(Application.chats_redis_key(application.token), chats)
  end
end
