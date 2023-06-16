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
    if params[:status] == "accepted"
      @join_request.update(status: "accepted")
      CommunityUser.create!(user_id: @join_request.user_id, community_id: @join_request.community_id, role: "member", status: "accepted" )
      redirect_to dashboard_path(@community), notice: 'Member added to community.'
    else
      @join_request.update(status: "rejected")
      redirect_to dashboard_path(@community), notice: 'Member request has been rejected.'
      community_user.destroy if community_user.present?
    end
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end

  def community_user
    @join_request = CommunityJoinRequest.find(params[:id])
    CommunityUser.find_by(user_id: @join_request.user_id, community_id: @join_request.community_id)
  end
end
