Company.delete_all
User.delete_all

#  smiths
smiths = Company.new(name: "Smith Co")
smiths.save(validate: false)

User.create!(name: "Howard", email: "howardjfraser@gmail.com", company: smiths, password: "password", activated: true, activated_at: Time.zone.now, role: "admin")

24.times do |n|
  name  = Faker::Name.name
  email = "user#{n+1}@smiths.com"
  password = "password"
  User.create!(name: name,
    email: email, company: smiths, password: password, activated: true, activated_at: Time.zone.now, role: "user")
end

# jones

jones = Company.new(name: "Jones & Co")
jones.save(validate: false)

12.times do |n|
  name  = Faker::Name.name
  email = "user#{n+1}@jones.com"
  password = "password"
  User.create!(name: name,
    email: email, company: jones, password: password, activated: true, activated_at: Time.zone.now, role: "user")
end

# starrs

starr = Company.new(name: "Starr Partners")
starr.save(validate: false)

48.times do |n|
  name  = Faker::Name.name
  email = "user#{n+1}@starr.com"
  password = "password"
  User.create!(name: name,
    email: email, company: starr, password: password, activated: true, activated_at: Time.zone.now, role: "user")
end

