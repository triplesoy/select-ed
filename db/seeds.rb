# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(
  first_name: "Miguel",
  last_name: "Bartolomeu",
  email: "miguel@aol.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  birthdate: DateTime.new(1970, 9, 15)

)

User.create(
  first_name: "Guillaume",
  last_name: "Soyer",
  email: "guillaume@aol.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  birthdate: DateTime.new(1988, 9, 15)
)

User.create(
  first_name: "Salim",
  last_name: "Atyieh",
  email: "salim@aol.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  birthdate: DateTime.new(1999, 9, 15)
)

User.create(
  first_name: "John",
  last_name: "Doe",
  email: "john@aol.com",
  password: "password",
  password_confirmation: "password",
  instagram_handle: "soyjr",
  admin: false,
  birthdate: DateTime.new(1976, 9, 15)
)

User.create(
  first_name: "Paul",
  last_name: "Doe",
  email: "paul@aol.com",
  password: "password",
  password_confirmation: "password",
  instagram_handle: "google",
  admin: false,
  birthdate: DateTime.new(2003, 9, 15)
)

User.create(
  first_name: "Jack",
  last_name: "Doe",
  email: "jack@aol.com",
  password: "password",
  password_confirmation: "password",
  instagram_handle: "cuevitasg",
  admin: false,
  birthdate: DateTime.new(1950, 9, 15)

)

User.create(
  first_name: "Tom",
  last_name: "Doe",
  email: "tom@aol.com",
  password: "password",
  password_confirmation: "password",
  instagram_handle: "sundaysundaymx",
  admin: false,
  birthdate: DateTime.new(1993, 9, 15)


)

Community.create(
  title: "Tech Enthusiasts",
  description: "A community for technology enthusiasts to discuss the latest trends and innovations.",
  country: "United States",
  city: "San Francisco",
  is_public: true,
  is_visible: true,
  category: "Technology",
  user_id: 1
)

Community.create(
  title: "Fitness Junkies",
  description: "Join us if you're passionate about fitness and living a healthy lifestyle.",
  country: "Canada",
  city: "Toronto",
  is_public: true,
  is_visible: true,
  category: "Sports",
  user_id: 1
)

Community.create(
  title: "Bookworms",
  description: "A community for book lovers to share their favorite reads and engage in literary discussions.",
  country: "United Kingdom",
  city: "London",
  is_public: true,
  is_visible: true,
  category: "Literature",
  user_id: 2
)

Community.create(
  title: "Artists Unite",
  description: "A community for artists of all kinds to showcase their work and collaborate with fellow creatives.",
  country: "Australia",
  city: "Sydney",
  is_public: false,
  is_visible: true,
  category: "Art",
  user_id: 3
)

Community.create(
  title: "Foodie Adventures",
  description: "Join us on culinary journeys as we explore different cuisines and share delicious recipes.",
  country: "United States",
  city: "New York",
  is_public: false,
  is_visible: true,
  category: "Food",
  user_id: 2
)

Community.create(
  title: "La fiesta de la noche",
  description: "Party all night long",
  country: "Spain",
  city: "Madrid",
  is_public: false,
  is_visible: true,
  category: "Party",
  user_id: 2
)

Event.create!(
  title: "Tech Conference 2023",
  start_time: DateTime.new(2023, 9, 15, 9, 0),
  end_time: DateTime.new(2023, 9, 17, 18, 0),
  address: "123 Main Street, San Francisco",
  description: "Join us for the biggest tech conference of the year, featuring keynote speakers and tech demos.",
  price: 99.99,
  capacity: 500,
  user_id: User.first.id,
  community_id: Community.first.id
)

Event.create!(
  title: "TEST",
  start_time: DateTime.new(2023, 9, 15, 9, 0),
  end_time: DateTime.new(2023, 9, 17, 18, 0),
  address: "123 rua do caralho",
  description: "TESTE.",
  price: 99.99,
  capacity: 500,
  user_id: User.second.id,
  community_id: Community.last.id
)

Event.create!(
  title: "cook 2024",
  start_time: DateTime.new(2023, 9, 15, 9, 0),
  end_time: DateTime.new(2023, 9, 17, 18, 0),
  address: "123 Main Street, San Francisco",
  description: "Join us for the biggest tech conference of the year, featuring keynote speakers and tech demos.",
  price: 99.99,
  capacity: 500,
  user_id: User.first.id,
  community_id: Community.first.id
)

Event.create!(
  title: "music festival",
  start_time: DateTime.new(2023, 9, 15, 9, 0),
  end_time: DateTime.new(2023, 9, 17, 18, 0),
  address: "123 Main Street, San Francisco",
  description: "Join us for the biggest tech conference of the year, featuring keynote speakers and tech demos.",
  price: 99.99,
  capacity: 500,
  user_id: 2,
  community_id: 6
)

Event.create!(
  title: "forest walk",
  start_time: DateTime.new(2023, 9, 15, 9, 0),
  end_time: DateTime.new(2023, 9, 17, 18, 0),
  address: "123 Main Street, San Francisco",
  description: "Join us for the biggest tech conference of the year, featuring keynote speakers and tech demos.",
  price: 99.99,
  capacity: 500,
  user_id: User.last.id,
  community_id: Community.first.id
)

Event.create!(
  title: "Tech Conference 2023",
  start_time: DateTime.new(2023, 9, 15, 9, 0),
  end_time: DateTime.new(2023, 9, 17, 18, 0),
  address: "Av. Álvaro Obregón 213, 06700 Ciudad de México, Ciudad de México",
  description: "Join us for the biggest tech conference of the year, featuring keynote speakers and tech demos.",
  price: 99.99,
  capacity: 500,
  user_id: User.last.id,
  community_id: Community.first.id
)

EventRsvp.create!(
  user_id: User.first.id,
  event_id: Event.first.id,
  status: "accepted"
)

EventRsvp.create!(
  user_id: User.first.id,
  event_id: Event.second.id,
  status: "accepted"
)

EventRsvp.create!(
  user_id: User.first.id,
  event_id: Event.third.id,
  status: "accepted"
)

EventRsvp.create!(
  user_id: User.last.id,
  event_id: Event.first.id,
  status: "accepted"
)


  CommunityJoinRequest.create!(
    user_id: 4,
    community_id: 1,
    status: "pending"
  )

  CommunityJoinRequest.create!(
    user_id: 4,
    community_id: 2,
    status: "pending"
  )

  CommunityJoinRequest.create!(
    user_id: 4,
    community_id: 3,
    status: "pending"
  )

  CommunityJoinRequest.create!(
    user_id: 4,
    community_id: 4,
    status: "pending"
  )

  CommunityJoinRequest.create!(
    user_id: 5,
    community_id: 1,
    status: "pending"
  )

  CommunityJoinRequest.create!(
    user_id: 5,
    community_id: 2,
    status: "pending"
  )

  CommunityJoinRequest.create!(
    user_id: 5,
    community_id: 2,
    status: "pending"
  )
  CommunityJoinRequest.create!(
    user_id: 4,
    community_id: 3,
    status: "pending"
  )

  CommunityJoinRequest.create!(
    user_id: 3,
    community_id: 6,
    status: "pending"
  )

  CommunityJoinRequest.create!(
    user_id: 4,
    community_id: 6,
    status: "pending"
  )

  CommunityJoinRequest.create!(
    user_id: 5,
    community_id: 6,
    status: "pending"
  )

  CommunityJoinRequest.create!(
    user_id: 6,
    community_id: 6,
    status: "pending"
  )

  CommunityJoinRequest.create!(
    user_id: 7,
    community_id: 6,
    status: "pending"
  )

puts "Seed data has been created successfully!"
