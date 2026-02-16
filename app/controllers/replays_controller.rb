require "net/http"

class ReplaysController < WebController
  def create
    webhook_request = WebhookRequest.find(params[:request_id])
    target_url = params[:target_url]

    unless target_url.present? && target_url.match?(%r{\Ahttps?://})
      redirect_back fallback_location: root_path, alert: "Invalid target URL."
      return
    end

    uri = URI.parse(target_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"
    http.open_timeout = 10
    http.read_timeout = 10

    req_class = {
      "GET" => Net::HTTP::Get,
      "POST" => Net::HTTP::Post,
      "PUT" => Net::HTTP::Put,
      "PATCH" => Net::HTTP::Patch,
      "DELETE" => Net::HTTP::Delete
    }[webhook_request.http_method] || Net::HTTP::Post

    http_req = req_class.new(uri.request_uri)
    http_req.body = webhook_request.body if webhook_request.body.present?
    webhook_request.formatted_headers.each do |key, value|
      next if %w[Host Connection].include?(key)
      http_req[key] = value
    end

    response = http.request(http_req)

    redirect_back fallback_location: root_path,
      notice: "Replayed! Got #{response.code} #{response.message}"
  rescue StandardError => e
    redirect_back fallback_location: root_path, alert: "Replay failed: #{e.message}"
  end
end
