class ChatsRepresenter
  def initialize(chats)
    @chats = chats
  end

  def as_json
    @chats.map do |chat|
      {
        chat_number: chat['chat_number'],
        messages_count: chat['messages_count']
      }
    end
  end
end