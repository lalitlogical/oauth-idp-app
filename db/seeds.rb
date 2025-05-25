# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# Create Admin User
user = User.find_or_create_by(email: 'lalit.logical@gmail.com') do |user|
  user.name = 'Lalit Kumar Maurya'
  user.display_name = 'Lalit'
  user.password = 'lalit.logical'
  user.admin = true
end

puts "User created with ID: #{user.id}"

# ✅ OIDC Interactive App (User Login)
application = Doorkeeper::Application.find_or_create_by!(name: "Web Frontend App") do |application|
  application.redirect_uri = "http://localhost:3001/oauth/callback http://client.myapp.local/oauth/callback http://client.lalit.local/oauth/callback"
  application.scopes = "openid profile email records"
  application.confidential = false
  application.uid = 'web-frontend-app-client-id'
  application.secret = 'web-frontend-app-client-secret'
end

puts "Doorkeeper::Application Web Frontend App created with ID: #{application.id}"

# ✅ Machine-to-Machine App (No User, Just Token)
application = Doorkeeper::Application.find_or_create_by!(name: "Internal API Client") do |application|
  application.scopes = "read_data write_data"
  application.confidential = true
  application.uid = 'api-client-id'
  application.secret = 'api-client-secret'
end

puts "Doorkeeper::Application Internal API Client created with ID: #{application.id}"
