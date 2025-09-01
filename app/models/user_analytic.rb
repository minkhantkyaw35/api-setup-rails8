class UserAnalytic < ApplicationRecord
  belongs_to :user

  validates :event_type, presence: true
  validates :occurred_at, presence: true

  scope :recent, -> { order(occurred_at: :desc) }
  scope :by_event_type, ->(type) { where(event_type: type) }
  scope :in_date_range, ->(start_date, end_date) { where(occurred_at: start_date..end_date) }

  EVENT_TYPES = %w[
    login
    logout
    registration
    device_registered
    device_removed
    password_changed
    profile_updated
    api_access
  ].freeze

  validates :event_type, inclusion: { in: EVENT_TYPES }

  before_create :set_occurred_at

  private

  def set_occurred_at
    self.occurred_at = Time.current if occurred_at.nil?
  end
end
