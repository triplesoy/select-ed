
User.create!(
  first_name: "Miguel",
  last_name: "Bartolomeu",
  email: "bartolomeu.miguel@gmail.com",
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
  email: "soyerg@gmail.com",
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
  email: "mailto:salimatiyeh@gmail.com",
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


      puts "Seed data has been create!d successfully!"
