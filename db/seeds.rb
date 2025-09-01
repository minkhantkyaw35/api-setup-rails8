# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
#
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "🌱 Seeding database..."

# Load permissions and roles from YAML configuration files
puts "📋 Loading permissions and roles from configuration..."
PermissionLoaderService.load_all

# Create a super admin user
super_admin_role = Role.find_by(name: 'super_admin')
super_admin = User.find_or_create_by(email: 'admin@pointsys.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'Super'
  user.last_name = 'Admin'
  user.is_active = true
end

# Assign super admin role
super_admin.user_roles.find_or_create_by(role: super_admin_role) if super_admin_role

# Create a test user  
user_role = Role.find_by(name: 'user')
test_user = User.find_or_create_by(email: 'user@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'Test'
  user.last_name = 'User'
  user.is_active = true
end

# Assign user role to test user
test_user.user_roles.find_or_create_by(role: user_role) if user_role

puts "✅ Database seeded successfully!"
puts "📧 Super Admin: admin@pointsys.com (password: password123)"
puts "📧 Test User: user@example.com (password: password123)"
puts "🔑 Created #{Permission.count} permissions"
puts "👥 Created #{Role.count} roles"
puts "👤 Created #{User.count} users"
