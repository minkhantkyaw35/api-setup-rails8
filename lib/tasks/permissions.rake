namespace :permissions do
  desc "Load permissions and roles from YAML configuration files"
  task load: :environment do
    puts "🔄 Loading permissions and roles from configuration files..."
    
    begin
      PermissionLoaderService.load_all
      
      puts "\n✅ Permissions and roles loaded successfully!"
      puts "📊 Summary:"
      puts "   📋 Total permissions: #{Permission.count}"
      puts "   👥 Total roles: #{Role.count}"
      
      Role.all.each do |role|
        puts "   🔑 #{role.name}: #{role.permissions.count} permissions"
      end
      
    rescue => e
      puts "❌ Error loading permissions: #{e.message}"
      puts e.backtrace.first(5) if Rails.env.development?
      exit 1
    end
  end

  desc "Show current permissions and roles"
  task show: :environment do
    puts "\n📋 Current Permissions:"
    puts "=" * 50
    
    Permission.all.group_by(&:resource).each do |resource, permissions|
      puts "\n#{resource.upcase}:"
      permissions.each do |perm|
        puts "  ✓ #{perm.name} (#{perm.action}) - #{perm.description}"
      end
    end
    
    puts "\n👥 Current Roles:"
    puts "=" * 50
    
    Role.all.each do |role|
      puts "\n#{role.name.upcase} - #{role.description}"
      puts "Permissions: #{role.permissions.count}"
      if role.permissions.any?
        role.permissions.limit(5).each do |perm|
          puts "  ✓ #{perm.name}"
        end
        puts "  ... and #{role.permissions.count - 5} more" if role.permissions.count > 5
      end
    end
  end

  desc "Reset all permissions and roles (DESTRUCTIVE - use with caution)"
  task reset: :environment do
    print "Are you sure you want to reset all permissions and roles? (y/N): "
    confirmation = STDIN.gets.chomp.downcase
    
    if confirmation == 'y' || confirmation == 'yes'
      puts "🗑️  Resetting permissions and roles..."
      
      # Remove all role-permission associations
      RolePermission.destroy_all
      
      # Remove all user-role associations  
      UserRole.destroy_all
      
      # Remove all permissions and roles
      Permission.destroy_all
      Role.destroy_all
      
      puts "✅ Reset complete. Run 'rails permissions:load' to reload from configuration files."
    else
      puts "❌ Reset cancelled."
    end
  end
end
