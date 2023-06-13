# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Community.create(
  title: "Tech Enthusiasts",
  description: "A community for technology enthusiasts to discuss the latest trends and innovations.",
  country: "United States",
  city: "San Francisco",
  is_public: true,
  is_visible: true,
  category: "Technology"
)

Community.create(
  title: "Fitness Junkies",
  description: "Join us if you're passionate about fitness and living a healthy lifestyle.",
  country: "Canada",
  city: "Toronto",
  is_public: true,
  is_visible: true,
  category: "Sports"
)

Community.create(
  title: "Bookworms",
  description: "A community for book lovers to share their favorite reads and engage in literary discussions.",
  country: "United Kingdom",
  city: "London",
  is_public: true,
  is_visible: true,
  category: "Literature"
)

Community.create(
  title: "Artists Unite",
  description: "A community for artists of all kinds to showcase their work and collaborate with fellow creatives.",
  country: "Australia",
  city: "Sydney",
  is_public: true,
  is_visible: true,
  category: "Art"
)

Community.create(
  title: "Foodie Adventures",
  description: "Join us on culinary journeys as we explore different cuisines and share delicious recipes.",
  country: "United States",
  city: "New York",
  is_public: true,
  is_visible: true,
  category: "Food"
)

Community.create(
  title: "Outdoor Explorers",
  description: "Connect with nature enthusiasts and plan exciting outdoor adventures like hiking, camping, and more.",
  country: "Canada",
  city: "Vancouver",
  is_public: true,
  is_visible: true,
  category: "Travel"
)

Community.create(
  title: "Film Fanatics",
  description: "A community for movie buffs to discuss their favorite films, actors, and upcoming releases.",
  country: "United Kingdom",
  city: "Manchester",
  is_public: true,
  is_visible: true,
  category: "Entertainment"
)
