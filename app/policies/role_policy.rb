class RolePolicy < ApplicationPolicy
  def admin_index?
    user.super_admin?
  end

  def admin_show?
    user.super_admin?
  end

  def admin_create?
    user.super_admin?
  end

  def admin_update?
    user.super_admin?
  end

  def admin_destroy?
    user.super_admin?
  end
end
