class RoleSerializer
  include JSONAPI::Serializer
  
  attributes :id, :name, :description, :created_at, :updated_at

  attribute :permissions do |role|
    role.permissions.select(:id, :name, :resource, :action, :description)
  end

  attribute :user_count do |role|
    role.users.count
  end
end
