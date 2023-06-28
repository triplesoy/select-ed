
User.create!(
  first_name: "Miguel",
  last_name: "Bartolomeu",
  email: "miguel@aol.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  birthdate: DateTime.new(1970, 9, 15),
  instagram_handle: "miguel",
  occupation: "Software Engineer",
  country: "Portugal"
)

User.create!(
  first_name: "Guillaume",
  last_name: "Soyer",
  email: "guillaume@aol.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  birthdate: DateTime.new(1988, 9, 15),
  instagram_handle: "soyjr",
  occupation: "Software Engineer",
  country: "France"
)

User.create!(
  first_name: "Salim",
  last_name: "Atyieh",
  email: "salim@aol.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  birthdate: DateTime.new(1999, 9, 15),
  instagram_handle: "salim",
  occupation: "Software Engineer",
  country: "Lebanon"
)

User.create!(
  first_name: "John",
  last_name: "Doe",
  email: "john@aol.com",
  password: "password",
  password_confirmation: "password",
  instagram_handle: "soyjr",
  admin: false,
  birthdate: DateTime.new(1976, 9, 15),
  occupation: "Software Engineer",
  country: "USA"
)

User.create!(
  first_name: "Paul",
  last_name: "Doe",
  email: "paul@aol.com",
  password: "password",
  password_confirmation: "password",
  instagram_handle: "google",
  admin: false,
  birthdate: DateTime.new(2003, 9, 15),
    occupation: "Software Engineer",
  country: "USA"
)

User.create!(
  first_name: "Jack",
  last_name: "Doe",
  email: "jack@aol.com",
  password: "password",
  password_confirmation: "password",
  instagram_handle: "cuevitasg",
  admin: false,
  birthdate: DateTime.new(1950, 9, 15),
  occupation: "Software Engineer",
  country: "USA"

)

User.create!(
  first_name: "Tom",
  last_name: "Doe",
  email: "tom@aol.com",
  password: "password",
  password_confirmation: "password",
  instagram_handle: "sundaysundaymx",
  admin: false,
  birthdate: DateTime.new(1993, 9, 15),

  occupation: "Software Engineer",
  country: "USA"
)


# Create some users
10.times do
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    country: Faker::Address.country,
    instagram_handle: Faker::Internet.username,
    occupation: Faker::Job.title
  )
end

# Create some communities and associate them with a user
10.times do
  Community.create(
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph(sentence_count: 5),
    short_description: Faker::Lorem.sentence(word_count: 10),
    category: Faker::Lorem.word,
    country: Faker::Address.country,
    city: Faker::Address.city,
    is_visible: Faker::Boolean.boolean,
    user: User.all.sample
  )
end

# Create some events and associate them with a community and a user
10.times do
  Event.create(
    title: Faker::Lorem.sentence(word_count: 3),
    address: Faker::Address.full_address,
    start_time: Faker::Time.forward(days: 23, period: :evening),
    end_time: Faker::Time.forward(days: 24, period: :morning),
    community: Community.all.sample,
    user: User.all.sample
  )
end

# Create some tickets and associate them with an event
10.times do
  Ticket.create(
    model: ["free", "regular", "vip"].sample,
    quantity: rand(50..100),
    event: Event.all.sample
  )
end

# Create some user tickets and associate them with a user and a ticket
10.times do
  UserTicket.create(
    scanned: ["accepted", "pending", "rejected"].sample,
    user: User.all.sample,
    ticket: Ticket.all.sample
  )
end

# Create some community users and associate them with a user and a community
10.times do
  CommunityUser.create(
    role: ["member", "admin", "moderator"].sample,
    user: User.all.sample,
    community: Community.all.sample
  )
end

# Create some community join requests and associate them with a user and a community
10.times do
  CommunityJoinRequest.create(
    status: ["accepted", "pending", "rejected"].sample,
    user: User.all.sample,
    community: Community.all.sample
  )
end

      puts "Seed data has been create!d successfully!"
