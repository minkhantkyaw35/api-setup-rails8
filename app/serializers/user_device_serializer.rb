class UserDeviceSerializer
  include JSONAPI::Serializer
  
  attributes :id, :device_name, :device_type, :device_identifier, :last_login_at, :ip_address, :is_active, :created_at

  attribute :user_agent_info do |device|
    # Parse user agent for better display
    device.user_agent&.truncate(100)
  end
end
