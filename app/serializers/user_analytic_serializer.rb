class UserAnalyticSerializer
  include JSONAPI::Serializer
  
  attributes :id, :event_type, :event_data, :ip_address, :user_agent, :occurred_at

  attribute :user_email do |analytic|
    analytic.user.email
  end
end
