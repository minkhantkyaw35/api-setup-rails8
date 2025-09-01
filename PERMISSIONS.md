# Permission Management System

This Rails application uses a YAML-based permission management system that provides a clean, maintainable way to define and manage permissions and roles.

## 📁 File Structure

```
config/permissions/
├── base_permissions.yml        # User, role, and permission management
├── analytics_permissions.yml   # Analytics and device management
├── api_permissions.yml         # API access and system administration
├── point_system_permissions.yml # Point system features
└── roles.yml                   # Role definitions and assignments
```

## 🚀 Quick Start

### Loading Permissions and Roles

```bash
# Load all permissions and roles from YAML files
rails permissions:load

# Show current permissions and roles
rails permissions:show

# Reset all permissions and roles (DESTRUCTIVE)
rails permissions:reset
```

### Database Setup

```bash
# Create and migrate database
rails db:create db:migrate

# Load permissions and create initial users
rails db:seed
```

## ✨ Adding New Permissions

### Method 1: Create New YAML File (Recommended for new features)

Create a new file in `config/permissions/` for your feature:

```yaml
# config/permissions/my_feature_permissions.yml
my_feature:
  - name: 'view_my_feature'
    resource: 'my_feature'
    action: 'read'
    description: 'View my feature data'
    
  - name: 'manage_my_feature'
    resource: 'my_feature'
    action: 'manage'
    description: 'Create, update, and delete my feature'
```

### Method 2: Add to Existing YAML File

Add new permissions to an existing category in any `*_permissions.yml` file:

```yaml
# Add to config/permissions/api_permissions.yml
api_access:
  - name: 'access_new_endpoint'
    resource: 'api'
    action: 'new_endpoint'
    description: 'Access to new API endpoint'
```

### Method 3: Update Role Assignments

Modify `config/permissions/roles.yml` to assign permissions to roles:

```yaml
roles:
  admin:
    name: 'admin'
    description: 'Administrator'
    permissions:
      - 'view_users'
      - 'view_my_feature'    # Add new permission
      - 'access_new_endpoint' # Add new permission
```

## 🔄 Workflow for Adding New Features

1. **Create or update YAML files** with new permissions
2. **Update roles.yml** to assign permissions to appropriate roles
3. **Run the load command**: `rails permissions:load`
4. **Verify changes**: `rails permissions:show`

## 📋 Permission Structure

Each permission should have:
- `name`: Unique identifier (snake_case)
- `resource`: The resource being controlled (e.g., 'user', 'post', 'api')
- `action`: The action being performed (e.g., 'read', 'create', 'update', 'delete')
- `description`: Human-readable description

## 👥 Role Types

- **super_admin**: Gets ALL permissions automatically
- **admin**: User management and system features
- **moderator**: Content management with limited admin access
- **premium_user**: Enhanced user with additional features
- **user**: Basic user with minimal permissions

## 🛡️ Usage in Controllers

```ruby
class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    authorize User, :view_users?
    # Your code here
  end
  
  def create
    authorize User, :create_users?
    # Your code here
  end
end
```

## 📚 Best Practices

### 1. **Naming Conventions**
- Permissions: `verb_resource` (e.g., `view_users`, `create_posts`)
- Resources: Singular nouns (e.g., `user`, `post`, `api`)
- Actions: Descriptive verbs (e.g., `read`, `create`, `manage`)

### 2. **File Organization**
- Group related permissions in the same file
- Use descriptive file names ending with `_permissions.yml`
- Keep roles separate in `roles.yml`

### 3. **Permission Granularity**
- Create specific permissions for different actions
- Avoid overly broad permissions
- Consider future needs when designing permissions

### 4. **Version Control**
- All YAML files are version controlled
- Changes are tracked and reviewable
- Easy to roll back changes

## 🔧 Troubleshooting

### Permission Not Found
```bash
# Reload permissions
rails permissions:load

# Check if permission exists
rails permissions:show | grep "permission_name"
```

### Role Assignment Issues
```bash
# Check user roles
User.find_by(email: 'user@example.com').roles.pluck(:name)

# Check role permissions
Role.find_by(name: 'admin').permissions.pluck(:name)
```

### Reset Everything
```bash
# ⚠️  DESTRUCTIVE - removes all permissions and roles
rails permissions:reset
rails permissions:load
```

## 🎯 Example: Adding Blog Feature

1. Create `config/permissions/blog_permissions.yml`:
```yaml
blog_management:
  - name: 'view_posts'
    resource: 'post'
    action: 'read'
    description: 'View blog posts'
    
  - name: 'create_posts'
    resource: 'post'
    action: 'create'
    description: 'Create new blog posts'
    
  - name: 'publish_posts'
    resource: 'post'
    action: 'publish'
    description: 'Publish draft posts'
```

2. Update `config/permissions/roles.yml`:
```yaml
roles:
  admin:
    permissions:
      - 'view_posts'
      - 'create_posts'
      - 'publish_posts'
      # ... existing permissions
      
  user:
    permissions:
      - 'view_posts'
      # ... existing permissions
```

3. Load the changes:
```bash
rails permissions:load
```

That's it! Your new blog permissions are now active and assigned to the appropriate roles.
