# Point System API 🚀

A modern Ruby on Rails API application with comprehensive authentication, authorization, and user analytics capabilities.

## 📋 Table of Contents

- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [Quick Start](#-quick-start)
- [API Documentation](#-api-documentation)
- [Authentication](#-authentication)
- [Authorization](#-authorization)
- [Database Schema](#-database-schema)
- [Environment Setup](#-environment-setup)
- [Development](#-development)

## ✨ Features

### 🔐 Authentication & Authorization
- **JWT-based Authentication** with secure token management
- **Dynamic Role & Permission System** - Super admins can create roles and permissions
- **Device Management** - Limit user access per device with configurable limits
- **Multi-device Support** - Users can login from multiple devices (limit configurable)
- **Secure Logout** - JWT token revocation and device deactivation

### 👥 User Management
- **User Registration & Login** with email/password
- **Profile Management** with first name, last name, phone
- **Account Status Control** (active/inactive users)
- **Role Assignment** - Dynamic role assignment by super admins
- **Device Tracking** - Track user devices, IP addresses, and login times

### 📊 Analytics & Monitoring
- **User Analytics** - Track user activities, logins, API usage
- **Device Analytics** - Monitor device registrations and usage
- **Event Tracking** - Comprehensive event logging system
- **Real-time Metrics** - User engagement and system metrics

### 🏗️ System Administration
- **Dynamic Permission Management** - Create, update, delete permissions
- **Role Management** - Flexible role creation and permission assignment
- **User Device Controls** - Force logout, device limit configuration
- **System Settings** - Configurable application settings

### 🔄 Point System (Extensible)
- **Point Management** - Award, deduct, transfer points
- **Point History** - Complete transaction tracking
- **Reward System** - Point-based reward redemption
- **Configurable Rules** - Dynamic point earning rules

## 🛠️ Technology Stack

### Backend Framework
- **Ruby 3.3.1** - Latest stable Ruby version
- **Rails 8.0** - Latest Rails with modern features
- **PostgreSQL** - Robust relational database

### Authentication & Security
- **Devise** - User authentication framework
- **Devise-JWT** - JSON Web Token authentication
- **Pundit** - Authorization framework with policies
- **Bcrypt** - Password hashing and security

### API & Serialization
- **JSON API Serializer** - Fast JSON serialization
- **Rack-CORS** - Cross-Origin Resource Sharing support
- **RESTful APIs** - Standard REST API conventions

### Development & Quality
- **Dotenv Rails** - Environment variable management
- **Annotate** - Model annotation for better documentation
- **Brakeman** - Security vulnerability scanner
- **RuboCop** - Code style and quality enforcement

### Database & Caching
- **PostgreSQL** - Primary database
- **Solid Cache** - Database-backed caching
- **Solid Queue** - Database-backed job processing
- **Solid Cable** - Database-backed WebSocket support

### Deployment & Infrastructure
- **Docker** - Containerization support
- **Kamal** - Modern deployment framework
- **Puma** - High-performance web server
- **Thruster** - HTTP acceleration and compression

## 🚀 Quick Start

### Prerequisites
- Ruby 3.2+ (3.3.1 recommended)
- PostgreSQL 12+
- Redis (optional, for advanced caching)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd point_sys
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup environment**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

4. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

5. **Start the server**
   ```bash
   rails server
   ```

### Default Users
After seeding, you'll have:
- **Super Admin**: admin@pointsys.com (password: password123)
- **Test User**: user@example.com (password: password123)

## 🔌 API Documentation

### Base URL
```
Development: http://localhost:3000/api/v1
Production: https://your-domain.com/api/v1
```

### Authentication Endpoints
```http
POST /api/v1/auth/login     # User login
POST /api/v1/auth/register  # User registration
DELETE /api/v1/auth/logout  # User logout
```

### User Management
```http
GET    /api/v1/users        # List users (admin)
GET    /api/v1/users/:id    # Get user details
PUT    /api/v1/users/:id    # Update user
DELETE /api/v1/users/:id    # Delete user (admin)
```

### Role & Permission Management
```http
GET    /api/v1/roles        # List roles
POST   /api/v1/roles        # Create role (super admin)
PUT    /api/v1/roles/:id    # Update role (super admin)
DELETE /api/v1/roles/:id    # Delete role (super admin)

GET    /api/v1/permissions  # List permissions
POST   /api/v1/permissions  # Create permission (super admin)
```

### Device Management
```http
GET    /api/v1/devices      # List user devices
POST   /api/v1/devices      # Register new device
DELETE /api/v1/devices/:id  # Remove device
```

### Analytics
```http
GET /api/v1/analytics/users     # User analytics (admin)
GET /api/v1/analytics/devices   # Device analytics (admin)
GET /api/v1/analytics/events    # Event analytics (admin)
```

## 🔐 Authentication

### JWT Token Structure
```json
{
  "user_id": 123,
  "email": "user@example.com",
  "roles": ["user"],
  "device_id": "device-uuid",
  "exp": 1630000000
}
```

### Request Headers
```http
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

### Login Response
```json
{
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "first_name": "John",
      "last_name": "Doe"
    },
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "device": {
      "id": 1,
      "device_name": "iPhone 12",
      "device_type": "mobile"
    }
  }
}
```

## 🛡️ Authorization

### Permission System
The application uses a dynamic permission system with the following structure:

- **Resources**: user, role, permission, device, analytics, api, content, points, rewards
- **Actions**: read, create, update, delete, manage, publish, etc.
- **Permissions**: Combination of resource + action (e.g., `view_users`, `create_roles`)

### Role Hierarchy
1. **super_admin** - Full system access, can manage everything
2. **admin** - User management, analytics, device management
3. **moderator** - Content management, limited admin features
4. **premium_user** - Enhanced features, private API access
5. **user** - Basic features, public API access

### Example Permission Checks
```ruby
# In controllers
authorize User, :view_users?
authorize Role, :create_roles?
authorize :analytics, :view_analytics?

# In models/views
current_user.has_permission?('user', 'read')
current_user.has_role?('admin')
current_user.super_admin?
```

## 🗄️ Database Schema

### Core Models
- **User** - User accounts with authentication
- **Role** - User roles (admin, user, etc.)
- **Permission** - Individual permissions
- **UserRole** - User-role associations
- **RolePermission** - Role-permission associations

### Device & Analytics
- **UserDevice** - Device tracking and management
- **UserAnalytic** - Event tracking and analytics
- **UserSetting** - User-specific settings (device limits, etc.)

### Security
- **JwtDenylist** - Revoked JWT tokens

## 🌍 Environment Setup

### Required Environment Variables
```bash
# Database
DATABASE_URL=postgresql://localhost/point_sys_development
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=your_password

# JWT Configuration
JWT_SECRET_KEY=your_secure_secret_key
JWT_EXPIRATION_TIME=24.hours

# Application
RAILS_ENV=development
DEFAULT_DEVICE_LIMIT=5
```

### Production Environment
```bash
# Rails Credentials (production)
rails credentials:edit

# Add:
# jwt_secret_key: your_production_secret
# database_password: your_production_db_password
```

## 👨‍💻 Development

### Code Quality
```bash
# Run tests
rails test

# Security scan
brakeman

# Code style
rubocop

# Check bundle
bundle audit
```

### Database Management
```bash
# Reset and reload permissions
rails permissions:reset
rails permissions:load

# Show current permissions
rails permissions:show

# Create migration
rails generate migration AddFeatureToModel

# Reset database (development only)
rails db:drop db:create db:migrate db:seed
```

### Adding New Features
1. **Add Permissions**: Create/edit YAML files in `config/permissions/`
2. **Load Permissions**: Run `rails permissions:load`
3. **Create Controllers**: Add API endpoints with authorization
4. **Add Policies**: Create Pundit policies for authorization
5. **Create Serializers**: Add JSON serializers for responses
6. **Write Tests**: Add comprehensive test coverage

### Performance Monitoring
```bash
# Check database performance
rails db:migrate:status

# Monitor logs
tail -f log/development.log

# Check memory usage
ps aux | grep puma
```

## 📚 Additional Resources

- [Permission Management Guide](PERMISSIONS.md)
- [API Testing Guide](docs/api_testing.md)
- [Deployment Guide](docs/deployment.md)
- [Security Best Practices](docs/security.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ using Ruby on Rails 8.0**
