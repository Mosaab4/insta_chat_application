class ChatCreateWorker
  include Sneakers::Worker

  from_queue "applications.chat.create", env: nil

  def work(application_token)
    data = JSON.load application_token
    token = data['token']

    application = Application.find_by(token: token)

    if application.nil?
      reject!
      return
    end

    CreateChatJob.perform_async(application.id, application.token)
    UpdateApplicationChatsCountJob.perform_in(2.seconds, application.id)

    ack!
  end
end