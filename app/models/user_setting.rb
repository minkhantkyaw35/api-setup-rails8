class UserSetting < ApplicationRecord
  belongs_to :user

  validates :device_limit, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 50 }

  before_validation :set_default_device_limit

  private

  def set_default_device_limit
    self.device_limit = ENV.fetch('DEFAULT_DEVICE_LIMIT', 5).to_i if device_limit.nil?
  end
end
