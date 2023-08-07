class CommunityJoinRequestsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_community, only: [:create, :update, :destroy]

  def create
    authorize CommunityJoinRequest
    existing_request = CommunityJoinRequest.find_by(user_id: current_user.id, community_id: @community.id)

    unless existing_request.present?
      if @community.public?
        @community.community_users.create!(user_id: current_user.id, community_id: @community.id, role: "member", status: "accepted" )
       redirect_to community_path(@community), notice: 'You are now a member of this community.'
      else
        @join_request = CommunityJoinRequest.new(user_id: current_user.id, community_id: @community.id, status: "pending")
        if @join_request.save!
          # Fetch the owner of the community
          community_owner = @community.owner

          # Send notification to the owner
          NewCommunityJoinRequestNotification.with(community_join_request: @join_request).deliver(community_owner) if community_owner.present?
          redirect_to community_path(@community), notice: 'Your request has been sent.'
        end
      end
    end
  end

  def update
    @join_request = CommunityJoinRequest.find(params[:id])
    authorize @join_request
    if params[:status] == "accepted"
      @join_request.update(status: "accepted")
      @community_user = CommunityUser.create!(user_id: @join_request.user_id, community_id: @join_request.community_id, role: "member", status: "accepted" )

      CommunityUserMailer.with(community_user: @community_user, user: @community_user.user, community: @community).accepted_community.deliver_now
      @join_request.destroy

      redirect_to dashboard_path(@community), notice:'Member added to community.'
    else
      @join_request.destroy
      redirect_to dashboard_path(@community), notice: 'Member request has been rejected.'
      community_user.destroy if community_user.present?
    end
  end


  def destroy
    @join_request = CommunityJoinRequest.find(params[:id])
    authorize @join_request
    @join_request.destroy
    redirect_to dashboard_path(@community), notice: 'Member request has been rejected.'
    community_user.destroy if community_user.present?
  end

  private

  def set_community
    @community = Community.friendly.find(params[:community_id])
  end

  def community_user
    @join_request = CommunityJoinRequest.find(params[:id])
    CommunityUser.find_by(user_id: @join_request.user_id, community_id: @join_request.community_id)
  end
end
