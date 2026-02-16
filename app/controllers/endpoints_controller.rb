class EndpointsController < WebController
  before_action :set_endpoint, only: [:show, :update, :destroy]
  before_action :require_login, only: [:index, :destroy]

  def index
    @endpoints = current_user.endpoints.active.order(created_at: :desc)
  end

  def create
    @endpoint = Endpoint.new(endpoint_params)
    @endpoint.user = current_user if logged_in?
    if @endpoint.save
      redirect_to endpoint_path(@endpoint.token)
    else
      redirect_to root_path, alert: "Could not create endpoint."
    end
  end

  def show
    if @endpoint.expired?
      redirect_to root_path, alert: "This endpoint has expired."
      return
    end
    @requests = @endpoint.webhook_requests.recent
    @requests = @requests.search(params[:q]) if params[:q].present?
    @requests = @requests.page(params[:page]) if @requests.respond_to?(:page)
  end

  def update
    if can_edit?(@endpoint)
      @endpoint.update(endpoint_params)
      redirect_to endpoint_path(@endpoint.token), notice: "Endpoint updated."
    else
      redirect_to endpoint_path(@endpoint.token), alert: "Not authorized."
    end
  end

  def destroy
    if @endpoint.user == current_user
      @endpoint.destroy
      redirect_to endpoints_path, notice: "Endpoint deleted."
    else
      redirect_to endpoints_path, alert: "Not authorized."
    end
  end

  private

  def set_endpoint
    @endpoint = Endpoint.find_by!(token: params[:token])
  end

  def endpoint_params
    params.permit(:name, :response_status_code, :response_body, :response_content_type)
  end

  def can_edit?(endpoint)
    return true if endpoint.user.nil? # anonymous endpoint
    return true if endpoint.user == current_user
    endpoint.team_members.exists?(user: current_user, role: "editor")
  end
end
