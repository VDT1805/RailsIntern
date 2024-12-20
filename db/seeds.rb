# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


puts "Start seeding"
App.find_or_create_by!(name: 'Datadog')
App.find_or_create_by!(name: 'Sentry')
App.find_or_create_by!(name: 'Dropbox')
App.find_or_create_by!(name: 'GoogleWorkspace')
Org.find_or_create_by!(name: "Company A").users.find_or_create_by!(email_address: "test@example.com") do |user|
  user.password = "123"
end

puts "Seeding done"
