Company.delete_all
User.delete_all

#  smiths
smiths = Company.new(name: 'Smith Co')
smiths.save(validate: false)

24.times do |n|
  name  = Faker::Name.name
  email = "user#{n + 1}@smiths.com"
  password = 'password'
  User.create!(name: name, email: email, company: smiths, password: password, activated: true,
               activated_at: Time.zone.now, role: 'user')
end

# jones
jones = Company.new(name: 'Jones & Co')
jones.save(validate: false)

12.times do |n|
  name  = Faker::Name.name
  email = "user#{n + 1}@jones.com"
  password = 'password'
  User.create!(name: name, email: email, company: jones, password: password, activated: true,
               activated_at: Time.zone.now, role: 'user')
end

# starrs
starr = Company.new(name: 'Starr Partners')
starr.save(validate: false)

48.times do |n|
  name  = Faker::Name.name
  email = "user#{n + 1}@starr.com"
  password = 'password'
  User.create!(name: name, email: email, company: starr, password: password, activated: true,
               activated_at: Time.zone.now, role: 'user')
end

# create admins

Company.all.each do |c|
  c.users.first.update_attribute(:role, 'admin')
end

# create root user

root = User.new(name: 'Howard', email: 'howardjfraser@gmail.com', company: Company.first, password: 'password',
                activated: true, activated_at: Time.zone.now, role: 'root')

root.save(validate: false)

# updates

messages = [
  "All good.",
  "Pretty terrible...",
  "Had a nice cup of tea but that's about it",
  "V. successful meeting with the MD and PA, (WTF?)",
  "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
]

User.all.each do |u|
  u.updates.build message: messages.sample
  u.save
end
