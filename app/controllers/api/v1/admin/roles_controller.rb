class Api::V1::Admin::RolesController < Api::V1::BaseController
  before_action :set_role, only: [:show, :update, :destroy]
  before_action :authorize_role

  def index
    @roles = Role.includes(:permissions)
    render json: RoleSerializer.new(@roles).serializable_hash, status: :ok
  end

  def show
    render json: RoleSerializer.new(@role).serializable_hash, status: :ok
  end

  def create
    @role = Role.new(role_params)
    
    if @role.save
      assign_permissions if params[:permission_ids].present?
      render json: RoleSerializer.new(@role).serializable_hash, status: :created
    else
      render_error('Failed to create role', :unprocessable_entity, @role.errors.full_messages)
    end
  end

  def update
    if @role.update(role_params)
      update_permissions if params[:permission_ids].present?
      render json: RoleSerializer.new(@role).serializable_hash, status: :ok
    else
      render_error('Failed to update role', :unprocessable_entity, @role.errors.full_messages)
    end
  end

  def destroy
    if @role.destroy
      render_success(nil, 'Role deleted successfully')
    else
      render_error('Failed to delete role')
    end
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name, :description)
  end

  def authorize_role
    authorize :role, "admin_#{action_name}?".to_sym
  end

  def assign_permissions
    @role.permission_ids = params[:permission_ids]
  end

  def update_permissions
    @role.permission_ids = params[:permission_ids]
  end
end
