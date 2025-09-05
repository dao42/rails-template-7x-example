# Do not remove admin init data, do not adjust default password!!!
puts 'Creating admin user at first time...'
Administrator.create_with(password: 'admin')
  .find_or_create_by!(name: 'admin')

# Write your seed data here
