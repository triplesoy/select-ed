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
  password_confirmation: "password"
)

User.create(
  first_name: "Guillaume",
  last_name: "Soyer",
  email: "guillaume@aol.com",
  password: "password",
  password_confirmation: "password"
)

User.create(
  first_name: "Salim",
  last_name: "Atyieh",
  email: "salim@aol.com",
  password: "password",
  password_confirmation: "password"
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
  is_public: true,
  is_visible: true,
  category: "Art",
  user_id: 2
)

Community.create(
  title: "Foodie Adventures",
  description: "Join us on culinary journeys as we explore different cuisines and share delicious recipes.",
  country: "United States",
  city: "New York",
  is_public: true,
  is_visible: true,
  category: "Food",
  user_id: 3
)
Event.create!(
  title: "Tech Conference 2023",
  start_time: DateTime.new(2023, 9, 15, 9, 0),
  end_time: DateTime.new(2023, 9, 17, 18, 0),
  address: "123 Main Street, San Francisco",
  description: "Join us for the biggest tech conference of the year, featuring keynote speakers and tech demos.",
  price: 99.99,
  capacity: 500,
  user_id:User.first.id,
  community_id:Community.first.id)

  Event.create!(
    title: "cook 2024",
    start_time: DateTime.new(2023, 9, 15, 9, 0),
    end_time: DateTime.new(2023, 9, 17, 18, 0),
    address: "123 Main Street, San Francisco",
    description: "Join us for the biggest tech conference of the year, featuring keynote speakers and tech demos.",
    price: 99.99,
    capacity: 500,
    user_id:User.first.id,
    community_id:Community.first.id)

    Event.create!(
      title: "music festival",
      start_time: DateTime.new(2023, 9, 15, 9, 0),
      end_time: DateTime.new(2023, 9, 17, 18, 0),
      address: "123 Main Street, San Francisco",
      description: "Join us for the biggest tech conference of the year, featuring keynote speakers and tech demos.",
      price: 99.99,
      capacity: 500,
      user_id:User.last.id,
      community_id:Community.first.id)

  EventRsvp.create!(
    user:User.first,
    event: Event.first
  )

  EventRsvp.create!(
    user:User.first,
    event: Event.second
  )

  EventRsvp.create!(
    user:User.first,
    event: Event.third
  )

  EventRsvp.create!(
    user:User.last,
    event: Event.first
  )
