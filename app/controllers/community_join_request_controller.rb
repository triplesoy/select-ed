class CommunityJoinRequestController < ApplicationController
before_action :authenticate_user!, only: [:create]
before_action :set_community_join_request_params, only: [:create]

  def index
  end

  def show
  end

  def new
  end

  def create
    @join_request = @community.join_requests.new(user: current_user)
    authorize @join_request

    if @join_request.save
      redirect_to @community, notice: 'Your request to join this community has been submitted.'
    else
      redirect_to @community, alert: 'There was an error submitting your request to join this community.'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_community_join_request_params
    @community = Community.find(params[:id])
  end
end
