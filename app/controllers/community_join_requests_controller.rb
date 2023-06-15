class CommunityJoinRequestsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_community, only: [:create, :update]

  def create
    authorize CommunityJoinRequest
    existing_request = CommunityJoinRequest.find_by(user_id: current_user.id, community_id: @community.id)

    unless existing_request.present?
      @join_request = CommunityJoinRequest.new(user_id: current_user.id, community_id: @community.id, status: "pending")
      if @join_request.save!
        redirect_to community_path(@community), notice: 'Your request has been sent.'
      else
        redirect_to community_path(@community), notice: 'Your request to join this community has failed.'
      end
    end
  end



  def update
    @join_request = CommunityJoinRequest.find(params[:id])
    authorize @join_request
    if @join_request.update(status: "accepted")
      CommunityUser.create(user_id: @join_request.user_id, community_id: @join_request.community_id, role: "member")
    elsif @join_request.update(status: "rejected")
      redirect_to community_path(@community), notice: 'Your request to join this community has been rejected.'
    end
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end
end
