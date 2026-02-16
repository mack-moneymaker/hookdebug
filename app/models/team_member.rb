class TeamMember < ApplicationRecord
  belongs_to :endpoint
  belongs_to :user

  validates :user_id, uniqueness: { scope: :endpoint_id }
  validates :role, inclusion: { in: %w[viewer editor] }
end
