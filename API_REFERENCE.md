# API Reference Guide

## 🔗 Base URL
```
Development: http://localhost:3000/api/v1
Production: https://your-domain.com/api/v1
```

## 🔑 Authentication

All authenticated requests require JWT token in header:
```http
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

## 📚 Endpoints

### 🔐 Authentication

#### Login
```http
POST /auth/login
Content-Type: application/json

{
  "user": {
    "email": "user@example.com",
    "password": "password123",
    "device_name": "iPhone 12",
    "device_type": "mobile"
  }
}
```

**Response:**
```json
{
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "is_active": true
    },
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "device": {
      "id": 1,
      "device_name": "iPhone 12",
      "device_type": "mobile",
      "is_active": true
    }
  }
}
```

#### Register
```http
POST /auth/register
Content-Type: application/json

{
  "user": {
    "email": "newuser@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "first_name": "John",
    "last_name": "Doe",
    "device_name": "iPhone 12",
    "device_type": "mobile"
  }
}
```

#### Logout
```http
DELETE /auth/logout
Authorization: Bearer <jwt-token>
```

### 👥 Users

#### List Users (Admin only)
```http
GET /users?page=1&limit=20
Authorization: Bearer <admin-token>
```

#### Get User Profile
```http
GET /users/me
Authorization: Bearer <jwt-token>
```

#### Update User
```http
PUT /users/me
Authorization: Bearer <jwt-token>

{
  "user": {
    "first_name": "Updated Name",
    "last_name": "Updated Last",
    "phone": "+1234567890"
  }
}
```

### 👑 Roles & Permissions (Admin)

#### List Roles
```http
GET /roles
Authorization: Bearer <admin-token>
```

#### Create Role (Super Admin)
```http
POST /roles
Authorization: Bearer <super-admin-token>

{
  "role": {
    "name": "custom_role",
    "description": "Custom role description",
    "permission_ids": [1, 2, 3]
  }
}
```

#### List Permissions
```http
GET /permissions
Authorization: Bearer <admin-token>
```

### 📱 Device Management

#### List User Devices
```http
GET /devices
Authorization: Bearer <jwt-token>
```

#### Remove Device
```http
DELETE /devices/:id
Authorization: Bearer <jwt-token>
```

#### Force Device Logout (Admin)
```http
POST /devices/:id/force_logout
Authorization: Bearer <admin-token>
```

### 📊 Analytics (Admin)

#### User Analytics
```http
GET /analytics/users?start_date=2024-01-01&end_date=2024-12-31
Authorization: Bearer <admin-token>
```

#### Device Analytics
```http
GET /analytics/devices
Authorization: Bearer <admin-token>
```

#### Event Analytics
```http
GET /analytics/events?event_type=login&limit=100
Authorization: Bearer <admin-token>
```

## 🔒 Permission Requirements

| Endpoint | Required Permission | Role Examples |
|----------|-------------------|---------------|
| `GET /users` | `view_users` | admin, super_admin |
| `POST /roles` | `create_roles` | super_admin |
| `GET /analytics/*` | `view_analytics` | admin, super_admin |
| `POST /devices/*/force_logout` | `force_device_logout` | admin, super_admin |
| `GET /permissions` | `view_permissions` | admin, super_admin |

## 📝 Standard Response Format

### Success Response
```json
{
  "data": {
    // Response data here
  },
  "meta": {
    "page": 1,
    "total_pages": 5,
    "total_count": 100
  }
}
```

### Error Response
```json
{
  "errors": [
    {
      "status": "401",
      "title": "Unauthorized",
      "detail": "You don't have permission to access this resource"
    }
  ]
}
```

## 🚨 HTTP Status Codes

| Code | Meaning | Example |
|------|---------|---------|
| 200 | OK | Successful GET, PUT |
| 201 | Created | Successful POST |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Invalid request data |
| 401 | Unauthorized | Missing/invalid token |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 422 | Unprocessable Entity | Validation errors |
| 500 | Internal Server Error | Server error |

## 🔧 Testing with cURL

### Login Example
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "admin@pointsys.com",
      "password": "password123",
      "device_name": "Test Device",
      "device_type": "desktop"
    }
  }'
```

### Authenticated Request Example
```bash
# Save token from login response
TOKEN="eyJhbGciOiJIUzI1NiJ9..."

curl -X GET http://localhost:3000/api/v1/users \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json"
```

## 🛠️ Development Tools

### Postman Collection
Import the following endpoints into Postman:
- Base URL: `{{base_url}}/api/v1`
- Auth Token: `{{auth_token}}`

### Environment Variables
```
base_url: http://localhost:3000
auth_token: <your-jwt-token>
```

---

**📚 For detailed implementation guides, see [README.md](README.md) and [PERMISSIONS.md](PERMISSIONS.md)**
