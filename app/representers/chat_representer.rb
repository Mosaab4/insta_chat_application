class ChatRepresenter
  def initialize(chat)
    @chat = chat
  end

  def as_json
    {
      chat_number: @chat.chat_number,
      messages_count: @chat.messages_count
    }
  end
end