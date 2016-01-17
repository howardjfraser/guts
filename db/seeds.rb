Company.delete_all
company = Company.new(name: "Smith Co")
company.save(validate: false)

User.delete_all

User.create!(name: "Howard", email: "howardjfraser@gmail.com", company: company, password: "password", password_confirmation: "password",
  admin: true, activated: true, activated_at: Time.zone.now)

User.create!(name: "Example User", email: "example@railstutorial.org", company: company, password: "foobar", password_confirmation: "foobar", activated: true, activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name, email: email, company: company, password: password, password_confirmation: password, activated: true, activated_at: Time.zone.now)
end
