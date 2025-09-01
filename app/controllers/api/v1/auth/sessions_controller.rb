class Api::V1::Auth::SessionsController < Devise::SessionsController
  include RackSessionFixController
  respond_to :json

  before_action :check_device_limit, only: [:create]

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      device_info = extract_device_info
      handle_device_login(resource, device_info)
      resource.track_login!(request.remote_ip, request.user_agent)
      
      render json: {
        success: true,
        message: 'Logged in successfully.',
        data: {
          user: UserSerializer.new(resource).serializable_hash[:data][:attributes],
          device_count: resource.active_devices_count,
          device_limit: resource.device_limit
        }
      }, status: :ok
    else
      render json: {
        success: false,
        message: "Invalid email or password."
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, 
                              Rails.application.credentials.jwt_secret_key || ENV['JWT_SECRET_KEY']).first
      current_user = User.find(jwt_payload['sub'])
      
      if current_user
        current_user.user_analytics.create!(
          event_type: 'logout',
          event_data: { logout_method: 'api' },
          ip_address: request.remote_ip,
          user_agent: request.user_agent,
          occurred_at: Time.current
        )
      end
    end
    
    render json: {
      success: true,
      message: "Logged out successfully."
    }, status: :ok
  rescue JWT::DecodeError
    render json: {
      success: false,
      message: "Couldn't find an active session."
    }, status: :unauthorized
  end

  private

  def extract_device_info
    {
      device_identifier: request.headers['X-Device-Identifier'],
      device_name: request.headers['X-Device-Name'] || 'Unknown Device',
      device_type: request.headers['X-Device-Type'] || 'Unknown',
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    }
  end

  def handle_device_login(user, device_info)
    return unless device_info[:device_identifier].present?

    existing_device = user.user_devices.find_by(device_identifier: device_info[:device_identifier])
    
    if existing_device
      existing_device.activate!
    elsif user.can_add_device?
      user.user_devices.create!(device_info.merge(is_active: true))
    else
      # Device limit exceeded - could implement policies here
      # For now, we'll allow login but won't register the device
    end
  end

  def check_device_limit
    return unless params[:user] && params[:user][:email]
    
    user = User.find_by(email: params[:user][:email])
    return unless user

    device_identifier = request.headers['X-Device-Identifier']
    return unless device_identifier.present?

    existing_device = user.user_devices.find_by(device_identifier: device_identifier)
    return if existing_device # Allow existing devices

    unless user.can_add_device?
      render json: {
        success: false,
        message: "Device limit exceeded. Please remove a device or contact administrator.",
        device_count: user.active_devices_count,
        device_limit: user.device_limit
      }, status: :forbidden
      return
    end
  end
end
