require 'securerandom'

20.times do
  Application.create({
     name: Faker::Name.unique.name,
     token: SecureRandom.uuid
   })
end


Application.all.each do |application|
  10.times do |count|
    application.chats.create(chat_number: count + 1)
  end
end