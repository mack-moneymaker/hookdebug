class WebhookRequest < ApplicationRecord
  belongs_to :endpoint

  validates :http_method, presence: true

  after_create_commit :broadcast_to_endpoint

  scope :recent, -> { order(created_at: :desc) }
  scope :search, ->(query) {
    return all if query.blank?
    where("http_method ILIKE :q OR body ILIKE :q OR source_ip ILIKE :q OR CAST(headers AS TEXT) ILIKE :q",
      q: "%#{query}%")
  }

  def formatted_headers
    headers || {}
  end

  def formatted_query_params
    query_params || {}
  end

  def parsed_body
    return nil if body.blank?
    JSON.parse(body) rescue body
  end

  private

  def broadcast_to_endpoint
    ActionCable.server.broadcast(
      "endpoint_#{endpoint.token}",
      {
        type: "new_request",
        html: ApplicationController.render(
          partial: "webhook_requests/request_row",
          locals: { request: self }
        ),
        request: {
          id: id,
          http_method: http_method,
          source_ip: source_ip,
          created_at: created_at.iso8601
        }
      }
    )
  end
end
