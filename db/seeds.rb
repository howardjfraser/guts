# reset

Company.destroy_all

# companies and users

company_sizes = [24, 12, 48, 6, 18]

company_sizes.each do |size|
  company = Company.new(name: Faker::Company.name)
  company.save(validate: false)
  puts company

  size.times do
    name  = Faker::Name.name
    email = Faker::Internet.safe_email(name)
    password = 'password'
    puts User.create!(name: name, email: email, company: company, password: password, activated: true,
                      activated_at: Time.zone.now, role: 'user')
  end
end

# admins

Company.all.each do |c|
  c.users.first.update_attribute(:role, 'admin') # owner
  (c.users.count / 12).times { c.users.sample.update_attribute(:role, 'admin') }
end

# root user

root = User.new(name: 'Howard', email: 'howardjfraser@gmail.com', company: Company.first, password: 'password',
                activated: true, activated_at: Time.zone.now, role: 'root')

root.save(validate: false)

# updates

User.all.each do |user|
  next unless rand < 0.9
  puts user.updates.build message: Faker::Lorem.sentence(10, true, 20)
  user.save

  update = Update.last
  update.update_attribute :created_at, (rand * 2).days.ago
end
