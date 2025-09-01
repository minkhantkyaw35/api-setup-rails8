class UserPolicy < ApplicationPolicy
  def show?
    user == record || user.super_admin?
  end

  def update?
    user == record || user.super_admin?
  end

  def destroy?
    user.super_admin?
  end

  # Admin actions
  def admin_index?
    user.super_admin?
  end

  def admin_show?
    user.super_admin?
  end

  def admin_update?
    user.super_admin?
  end

  def admin_destroy?
    user.super_admin?
  end

  def admin_assign_roles?
    user.super_admin?
  end

  def admin_analytics?
    user.super_admin?
  end

  def admin_update_device_limit?
    user.super_admin?
  end
end
