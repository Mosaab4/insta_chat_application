class ApplicationsRepresenter
  def initialize(applications)
    @applications = applications
  end

  def as_json

    @applications.map do |application|
      {
        name: application.name,
        token: application.token,
        chats_count: application.chats_count
      }
    end
  end
end