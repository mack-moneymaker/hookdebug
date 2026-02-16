class TeamMembersController < WebController
  before_action :require_login
  before_action :set_endpoint

  def create
    user = User.find_by(email: params[:email])
    unless user
      redirect_back fallback_location: endpoint_path(@endpoint.token), alert: "User not found."
      return
    end

    member = @endpoint.team_members.build(user: user, role: params[:role] || "viewer")
    if member.save
      redirect_to endpoint_path(@endpoint.token), notice: "Team member added."
    else
      redirect_to endpoint_path(@endpoint.token), alert: member.errors.full_messages.join(", ")
    end
  end

  def destroy
    member = @endpoint.team_members.find(params[:id])
    member.destroy
    redirect_to endpoint_path(@endpoint.token), notice: "Team member removed."
  end

  private

  def set_endpoint
    @endpoint = Endpoint.find_by!(token: params[:endpoint_token])
    unless @endpoint.user == current_user
      redirect_to root_path, alert: "Not authorized."
    end
  end
end
