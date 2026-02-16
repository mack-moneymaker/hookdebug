class EndpointChannel < ApplicationCable::Channel
  def subscribed
    stream_from "endpoint_#{params[:token]}"
  end

  def unsubscribed
  end
end
