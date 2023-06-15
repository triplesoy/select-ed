class CommunityUsersController < ApplicationController
  before_action :set_community_user, only: [:update, :destroy]
  before_action :set_community, only: [:create, :update, :destroy]

  def create
    @community_user = CommunityUser.new(community_user_params)
    @community_user.community = @community
    authorize @community_user

    if @community_user.save
      redirect_to @community, notice: 'User successfully added to the community.'
    else
      redirect_to @community, alert: 'Failed to add user to the community.'
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
    @community_user.destroy
    redirect_to @community, notice: 'Community user successfully removed.'
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
