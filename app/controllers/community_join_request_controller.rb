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
    authorize @join_request
    @join_request = CommunityJoinRequest.new(user_id: current_user.id, community_id: params[:community_id], status: "pending")
    if @join_request.save
      redirect_to community_path(@community), notice: 'Your request to join this community has been submitted.'
    else
      redirect_to community_path(@community), alert: 'There was an error submitting your request to join this community.'
    end

  end

  def edit
  end

  def update
    authorize @join_request
    @join_request = CommunityJoinRequest.find(params[:id])
    if @join_request.update(status: "accepted")
      CommunityUser.create(user_id: join_request.user_id, community_id: join_request.community_id, role: "member")
    elseif join_request.update(status: "rejected")
      redirect_to community_path(@community), notice: 'Your request to join this community has been rejected.'
    end
  end

  def destroy
  end

  private

  def set_community_join_request_params
    @community = Community.find(params[:id])
  end
end
