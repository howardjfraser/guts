Company.destroy_all

#  smiths
smiths = Company.new(name: 'Smith Co')
smiths.save(validate: false)

24.times do |n|
  name  = Faker::Name.name
  email = "user#{n + 1}@smiths.com"
  password = 'password'
  puts User.create!(name: name, email: email, company: smiths, password: password, activated: true,
               activated_at: Time.zone.now, role: 'user')
end

# jones
jones = Company.new(name: 'Jones & Co')
jones.save(validate: false)

12.times do |n|
  name  = Faker::Name.name
  email = "user#{n + 1}@jones.com"
  password = 'password'
  puts User.create!(name: name, email: email, company: jones, password: password, activated: true,
               activated_at: Time.zone.now, role: 'user')
end

# starrs
starr = Company.new(name: 'Starr Partners')
starr.save(validate: false)

48.times do |n|
  name  = Faker::Name.name
  email = "user#{n + 1}@starr.com"
  password = 'password'
  puts User.create!(name: name, email: email, company: starr, password: password, activated: true,
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

User.all.each do |user|
  next unless rand < 0.9
  user.updates.build message: Faker::Lorem.sentence(10, true, 20)
  user.save

  update = Update.last
  update.update_attribute :created_at, (rand * 3).days.ago
end
