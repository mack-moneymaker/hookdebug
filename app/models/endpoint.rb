class Endpoint < ApplicationRecord
  belongs_to :user, optional: true
  has_many :webhook_requests, dependent: :destroy
  has_many :team_members, dependent: :destroy

  before_create :generate_token
  before_create :set_expiration

  scope :active, -> { where("expires_at IS NULL OR expires_at > ?", Time.current) }
  scope :expired, -> { where("expires_at IS NOT NULL AND expires_at <= ?", Time.current) }

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def permanent?
    expires_at.nil?
  end

  def webhook_url
    "/webhook/#{token}"
  end

  def max_requests
    user&.pro? ? nil : 50
  end

  def enforce_request_limit!
    return unless max_requests
    excess = webhook_requests.count - max_requests
    webhook_requests.order(created_at: :asc).limit(excess).destroy_all if excess > 0
  end

  private

  def generate_token
    self.token ||= SecureRandom.hex(16)
  end

  def set_expiration
    return if user&.pro?
    self.expires_at ||= 48.hours.from_now
  end
end
