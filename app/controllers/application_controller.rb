class ApplicationController < ActionController::API
  include Pundit::Authorization
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone])
  end

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action.' }, status: :forbidden
  end

  def current_user_device
    return nil unless current_user
    
    device_identifier = request.headers['X-Device-Identifier']
    return nil unless device_identifier

    current_user.user_devices.find_by(device_identifier: device_identifier)
  end

  def track_user_activity(event_type, event_data = {})
    return unless current_user

    current_user.user_analytics.create!(
      event_type: event_type,
      event_data: event_data,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      occurred_at: Time.current
    )
  end
end
