class CommunityJoinRequestController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def community_join_request_params
    params.require(:community_join_request).permit(:title, :description, :country, :city, :is_public, :is_visible)
  end

  def set_community
    @community = Community.find(params[:id])
  end
end
