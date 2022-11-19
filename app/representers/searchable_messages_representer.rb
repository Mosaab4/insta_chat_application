class SearchableMessagesRepresenter
  def initialize(messages)
    @messages = messages
  end

  def as_json
    @messages.map do |message|
      {
        message_number: message._source.message_number,
        body: message._source.body,
      }
    end
  end

end