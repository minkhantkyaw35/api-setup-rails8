class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show, :update]

  def show
    authorize @user
    render json: UserSerializer.new(@user).serializable_hash, status: :ok
  end

  def update
    authorize @user
    if @user.update(user_params)
      track_user_activity('profile_updated', { fields_updated: user_params.keys })
      render json: UserSerializer.new(@user).serializable_hash, status: :ok
    else
      render_error('Failed to update profile', :unprocessable_entity, @user.errors.full_messages)
    end
  end

  def my_analytics
    start_date = params[:start_date] ? Date.parse(params[:start_date]) : 30.days.ago
    end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.current
    
    analytics = current_user.user_analytics
                           .in_date_range(start_date, end_date)
                           .recent
                           .limit(params[:limit] || 50)

    render json: UserAnalyticSerializer.new(analytics).serializable_hash, status: :ok
  end

  def my_devices
    devices = current_user.user_devices.order(:created_at)
    render json: UserDeviceSerializer.new(devices).serializable_hash, status: :ok
  end

  def remove_device
    device = current_user.user_devices.find(params[:device_id])
    
    if device.destroy
      track_user_activity('device_removed', { 
        device_name: device.device_name,
        device_identifier: device.device_identifier 
      })
      render_success(nil, 'Device removed successfully')
    else
      render_error('Failed to remove device')
    end
  end

  private

  def set_user
    @user = params[:id] == 'me' ? current_user : User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone)
  end
end
