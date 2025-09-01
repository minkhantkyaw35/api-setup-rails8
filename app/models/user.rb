class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  # Associations
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :user_devices, dependent: :destroy
  has_many :user_analytics, dependent: :destroy
  has_one :user_setting, dependent: :destroy

  # Callbacks
  after_create :create_default_user_setting
  after_create :assign_default_role

  # Validations
  validates :email, presence: true, uniqueness: true

  # Instance methods
  def has_role?(role_name)
    roles.exists?(name: role_name)
  end

  def has_permission?(resource, action)
    roles.joins(:permissions).exists?(
      permissions: { resource: resource, action: action }
    )
  end

  def super_admin?
    has_role?('super_admin')
  end

  def device_limit
    user_setting&.device_limit || ENV.fetch('DEFAULT_DEVICE_LIMIT', 5).to_i
  end

  def active_devices_count
    user_devices.where(is_active: true).count
  end

  def can_add_device?
    active_devices_count < device_limit
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def track_login!(ip_address, user_agent)
    update!(last_login_at: Time.current)
    user_analytics.create!(
      event_type: 'login',
      event_data: { login_method: 'api' },
      ip_address: ip_address,
      user_agent: user_agent,
      occurred_at: Time.current
    )
  end

  private

  def create_default_user_setting
    create_user_setting!(device_limit: ENV.fetch('DEFAULT_DEVICE_LIMIT', 5).to_i)
  end

  def assign_default_role
    default_role = Role.find_by(name: 'user')
    if default_role
      user_roles.create!(role: default_role)
    end
  end
end
