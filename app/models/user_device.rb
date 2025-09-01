class UserDevice < ApplicationRecord
  belongs_to :user

  validates :device_identifier, presence: true, uniqueness: true
  validates :device_name, presence: true
  validates :device_type, presence: true

  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }

  before_create :set_defaults
  after_create :track_device_registration

  def activate!
    update!(is_active: true, last_login_at: Time.current)
  end

  def deactivate!
    update!(is_active: false)
  end

  private

  def set_defaults
    self.is_active = true if is_active.nil?
    self.last_login_at = Time.current if last_login_at.nil?
  end

  def track_device_registration
    user.user_analytics.create!(
      event_type: 'device_registered',
      event_data: {
        device_name: device_name,
        device_type: device_type,
        device_identifier: device_identifier
      },
      ip_address: ip_address,
      user_agent: user_agent,
      occurred_at: Time.current
    )
  end
end
