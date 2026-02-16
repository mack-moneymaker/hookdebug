class WebhooksController < ActionController::API
  # This must be FAST — store and broadcast, nothing else
  def receive
    endpoint = Endpoint.active.find_by(token: params[:token])

    unless endpoint
      render json: { error: "Endpoint not found or expired" }, status: :not_found
      return
    end

    webhook_request = endpoint.webhook_requests.create!(
      http_method: request.method,
      headers: extract_headers,
      body: request.raw_post,
      query_params: request.query_parameters,
      content_type: request.content_type,
      source_ip: request.remote_ip
    )

    # Enforce request limits asynchronously would be better, but inline for MVP
    endpoint.enforce_request_limit!

    render(
      body: endpoint.response_body,
      content_type: endpoint.response_content_type,
      status: endpoint.response_status_code
    )
  end

  private

  def extract_headers
    request.headers.to_h.select { |k, _| k.start_with?("HTTP_") || %w[CONTENT_TYPE CONTENT_LENGTH].include?(k) }
      .transform_keys { |k| k.sub(/^HTTP_/, "").split("_").map(&:capitalize).join("-") }
  end
end
