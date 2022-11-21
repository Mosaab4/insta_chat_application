class CreateMessageJob
  include Sidekiq::Job

  def perform(chat_id, body, chat_number,application_token)
    message_number = 0

    ActiveRecord::Base.transaction do
      ActiveRecord::Base.with_advisory_lock("add_message_#{chat_number.to_s}_#{application_token}_lock") do
        last_message_entry = Message.where(chat_id: chat_id).order('id DESC').first

        unless last_message_entry.nil?
          message_number = last_message_entry.message_number
        end

        Message.create(body: body, chat_id: chat_id, message_number: message_number + 1)

        $redis.del(Chat.messages_redis_key(chat_number,application_token))
      end
    end
  end
end
