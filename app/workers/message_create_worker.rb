class MessageCreateWorker
  include Sneakers::Worker

  from_queue "applications.message.create", env: nil

  def work(data)
    data = JSON.load data
    token = data['token']

    application = Application.find_by(token: token)

    if application.nil?
      reject!
      return
    end

    chat = Chat.where(application: application.id, chat_number: data['chat_number']).first

    if chat.nil?
      reject!
      return
    end

    CreateMessageJob.perform_async(chat.id, data['body'], data['chat_number'], application.token)
    UpdateChatMessagesCountJob.perform_in(10.seconds, chat.id)
    ack!
  end
end