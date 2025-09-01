class Api::V1::Admin::PermissionsController < Api::V1::BaseController
  before_action :set_permission, only: [:show, :update, :destroy]
  before_action :authorize_permission

  def index
    @permissions = Permission.all
    render json: PermissionSerializer.new(@permissions).serializable_hash, status: :ok
  end

  def show
    render json: PermissionSerializer.new(@permission).serializable_hash, status: :ok
  end

  def create
    @permission = Permission.new(permission_params)
    
    if @permission.save
      render json: PermissionSerializer.new(@permission).serializable_hash, status: :created
    else
      render_error('Failed to create permission', :unprocessable_entity, @permission.errors.full_messages)
    end
  end

  def update
    if @permission.update(permission_params)
      render json: PermissionSerializer.new(@permission).serializable_hash, status: :ok
    else
      render_error('Failed to update permission', :unprocessable_entity, @permission.errors.full_messages)
    end
  end

  def destroy
    if @permission.destroy
      render_success(nil, 'Permission deleted successfully')
    else
      render_error('Failed to delete permission')
    end
  end

  private

  def set_permission
    @permission = Permission.find(params[:id])
  end

  def permission_params
    params.require(:permission).permit(:name, :resource, :action, :description)
  end

  def authorize_permission
    authorize :permission, "admin_#{action_name}?".to_sym
  end
end
