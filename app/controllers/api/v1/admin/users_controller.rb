class Api::V1::Admin::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show, :update, :destroy, :assign_roles, :analytics]
  before_action :authorize_user_management

  def index
    @users = User.includes(:roles, :user_setting)
                 .page(params[:page])
                 .per(params[:per_page] || 20)
    
    render json: UserSerializer.new(@users).serializable_hash, status: :ok
  end

  def show
    render json: UserSerializer.new(@user).serializable_hash, status: :ok
  end

  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash, status: :ok
    else
      render_error('Failed to update user', :unprocessable_entity, @user.errors.full_messages)
    end
  end

  def destroy
    if @user.destroy
      render_success(nil, 'User deleted successfully')
    else
      render_error('Failed to delete user')
    end
  end

  def assign_roles
    if params[:role_ids].present?
      @user.role_ids = params[:role_ids]
      render json: UserSerializer.new(@user.reload).serializable_hash, status: :ok
    else
      render_error('Role IDs are required')
    end
  end

  def analytics
    start_date = params[:start_date] ? Date.parse(params[:start_date]) : 30.days.ago
    end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.current
    
    analytics = @user.user_analytics
                    .in_date_range(start_date, end_date)
                    .recent
                    .limit(params[:limit] || 100)

    render json: UserAnalyticSerializer.new(analytics).serializable_hash, status: :ok
  end

  def update_device_limit
    user = User.find(params[:user_id])
    device_limit = params[:device_limit].to_i

    if device_limit > 0 && device_limit <= 50
      user.user_setting.update!(device_limit: device_limit)
      render_success({ device_limit: device_limit }, 'Device limit updated successfully')
    else
      render_error('Device limit must be between 1 and 50')
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :is_active)
  end

  def authorize_user_management
    authorize :user, "admin_#{action_name}?".to_sym
  end
end
