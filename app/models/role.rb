class Role < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions

  validates :name, presence: true, uniqueness: true

  def self.super_admin_role
    find_or_create_by(name: 'super_admin') do |role|
      role.description = 'Super Administrator with full access'
    end
  end

  def self.default_user_role
    find_or_create_by(name: 'user') do |role|
      role.description = 'Default user role'
    end
  end
end
