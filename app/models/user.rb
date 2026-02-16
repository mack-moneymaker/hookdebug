class User < ApplicationRecord
  has_secure_password

  has_many :endpoints, dependent: :destroy
  has_many :team_members, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def pro?
    plan == "pro"
  end
end
