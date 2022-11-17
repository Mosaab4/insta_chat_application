require 'securerandom'

20.times do
  Application.create({
     name: Faker::Name.name,
     token: SecureRandom.uuid
   })
end