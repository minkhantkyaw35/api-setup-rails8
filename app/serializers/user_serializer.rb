class UserSerializer
  include JSONAPI::Serializer
  
  attributes :id, :email, :first_name, :last_name, :phone, :is_active, :last_login_at, :created_at

  attribute :full_name do |user|
    user.full_name
  end

  attribute :roles do |user|
    user.roles.pluck(:name)
  end

  attribute :device_count do |user|
    user.active_devices_count
  end

  attribute :device_limit do |user|
    user.device_limit
  end

  attribute :can_add_device do |user|
    user.can_add_device?
  end
end
