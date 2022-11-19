class MessagesRepresenter
  def initialize(messages)
    @messages = messages
  end

  def as_json
    @messages.map do |message|
      {
        body: message['body'],
        message_number: message['message_number']
      }
    end
  end
end