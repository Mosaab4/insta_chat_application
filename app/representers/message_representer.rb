class MessageRepresenter
  def initialize(message)
    @message = message
  end

  def as_json
    {
      body: @message.body,
      message_number: @message.message_number
    }
  end
end