class CommunityUsersController < ApplicationController
  before_action :set_community_user, only: [:update, :destroy]
  before_action :set_community, only: [:create, :update, :destroy]

  def create
    @community_user = CommunityUser.new(community_user_params)
    @community_user.community = @community
    authorize @community_user

    if @community_user.save
      redirect_to @community, notice: 'User successfully added to the community.'
      CommunityJoinRequest.find_by(user: @community_user.user, community: @community).destroy
    else
      redirect_to @community, alert: 'Failed to add user to the community.'
    end
  end



  # Def make moderator
  # if current user is admin of the website or admin of the community
  # they can update role of the member to moderator
  # but they can't update their roles (as admins) to moderator, and should get a message saying "you can't make yourself or an admin moderator"

  # def remove moderator
  # if current user is admin of the website or admin of the community
  # they can update/revoke role of  moderator to member
  # but they can't update their roles (as admins) to member

  # write the code :



def make_moderator
  @community_user = CommunityUser.find(params[:id])
  authorize @community_user
  if current_user == @community_user.user
    redirect_to dashboard_path(@community_user.community), alert: 'As an admint, you cannot make yourself moderator.'
  elsif (current_user.admin || current_user == @community_user.community.user)
    @community_user.update(role: "moderator")
    redirect_to dashboard_path(@community_user.community), notice: 'User successfully made moderator.'
  else
    redirect_to dashboard_path(@community_user.community), alert: 'Only admins can make moderators.'
  end
end

def remove_moderator
  @community_user = CommunityUser.find(params[:id])
  authorize @community_user
  if current_user == @community_user.user
    redirect_to dashboard_path(@community_user.community), alert: 'You cannot remove yourself as moderator.'
  elsif (current_user.admin || current_user == @community_user.community.user)
    @community_user.update(role: "member")
    redirect_to dashboard_path(@community_user.community), notice: 'User successfully removed as moderator.'
  else
    redirect_to dashboard_path(@community_user.community), alert: 'Only admins can make moderators.'
  end
end


  def update
    authorize @community_user
    if @community_user.update(community_user_params)
      redirect_to @community, notice: 'Community user successfully updated.'
    else
      redirect_to @community, alert: 'Failed to update community user.'
    end
  end

  def destroy
    authorize @community_user
    if @community_user.role == 'admin'
      redirect_to dashboard_path(@community), alert: 'Admin user cannot be removed.'
    else
      @community_user.destroy
      redirect_to dashboard_path(@community), notice: 'Community user successfully removed.'
    end
  end

  private

  def community_user_params
    params.require(:community_user).permit(:role, :status, :user_id)
  end

  def set_community_user
    @community_user = CommunityUser.find(params[:id])
  end

  def set_community
    @community = Community.find(params[:community_id])
  end
end
