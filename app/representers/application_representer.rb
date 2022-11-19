class ApplicationRepresenter
  def initialize(application)
    @application = application
  end

  def as_json
    {
      name: @application['name'],
      token: @application['token'],
      chats_count: @application['chats_count']
    }
  end
end