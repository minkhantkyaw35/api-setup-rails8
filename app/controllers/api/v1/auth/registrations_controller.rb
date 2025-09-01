class Api::V1::Auth::RegistrationsController < Devise::RegistrationsController
  include RackSessionFixController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      device_info = extract_device_info
      register_device(resource, device_info) if device_info[:device_identifier].present?
      
      render json: {
        success: true,
        message: 'Signed up successfully.',
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    elsif request.method == "DELETE"
      render json: {
        success: true,
        message: "Account deleted successfully."
      }, status: :ok
    else
      render json: {
        success: false,
        message: "User couldn't be created successfully.",
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone)
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

  def register_device(user, device_info)
    return unless device_info[:device_identifier].present?

    existing_device = user.user_devices.find_by(device_identifier: device_info[:device_identifier])
    
    if existing_device
      existing_device.activate!
    elsif user.can_add_device?
      user.user_devices.create!(device_info)
    else
      # Could implement device limit exceeded logic here
    end
  end
end
