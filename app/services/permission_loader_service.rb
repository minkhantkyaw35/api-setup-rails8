class PermissionLoaderService
  def self.load_all
    new.load_all
  end

  def load_all
    load_permissions
    load_roles
    assign_permissions_to_roles
  end

  private

  def load_permissions
    permission_files = Dir[Rails.root.join('config', 'permissions', '*_permissions.yml')]
    
    permission_files.each do |file|
      load_permissions_from_file(file)
    end
  end

  def load_permissions_from_file(file)
    data = YAML.load_file(file)
    
    data.each do |category, permissions|
      puts "📋 Loading #{category} permissions..."
      
      permissions.each do |perm_data|
        permission = Permission.find_or_create_by(name: perm_data['name']) do |p|
          p.resource = perm_data['resource']
          p.action = perm_data['action']
          p.description = perm_data['description']
        end
        
        # Update existing permissions if data has changed
        if permission.persisted? && 
           (permission.resource != perm_data['resource'] || 
            permission.action != perm_data['action'] || 
            permission.description != perm_data['description'])
          
          permission.update!(
            resource: perm_data['resource'],
            action: perm_data['action'],
            description: perm_data['description']
          )
          puts "  ↻ Updated permission: #{perm_data['name']}"
        elsif !permission.persisted?
          puts "  ✅ Created permission: #{perm_data['name']}"
        end
      end
    end
  end

  def load_roles
    roles_file = Rails.root.join('config', 'permissions', 'roles.yml')
    return unless File.exist?(roles_file)
    
    data = YAML.load_file(roles_file)
    
    data['roles'].each do |role_key, role_data|
      role = Role.find_or_create_by(name: role_data['name']) do |r|
        r.description = role_data['description']
      end
      
      # Update description if changed
      if role.persisted? && role.description != role_data['description']
        role.update!(description: role_data['description'])
        puts "  ↻ Updated role: #{role_data['name']}"
      elsif !role.persisted?
        puts "  ✅ Created role: #{role_data['name']}"
      end
    end
  end

  def assign_permissions_to_roles
    roles_file = Rails.root.join('config', 'permissions', 'roles.yml')
    return unless File.exist?(roles_file)
    
    data = YAML.load_file(roles_file)
    
    data['roles'].each do |role_key, role_data|
      role = Role.find_by(name: role_data['name'])
      next unless role
      
      if role_data['permissions'] == 'all'
        # Super admin gets all permissions
        role.permissions = Permission.all
        puts "  🔑 Assigned ALL permissions to #{role.name}"
      elsif role_data['permissions'].is_a?(Array)
        # Assign specific permissions
        permissions = Permission.where(name: role_data['permissions'])
        role.permissions = permissions
        puts "  🔑 Assigned #{permissions.count} permissions to #{role.name}"
      end
    end
  end
end
