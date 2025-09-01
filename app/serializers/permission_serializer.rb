class PermissionSerializer
  include JSONAPI::Serializer
  
  attributes :id, :name, :resource, :action, :description, :created_at, :updated_at

  attribute :role_count do |permission|
    permission.roles.count
  end
end
