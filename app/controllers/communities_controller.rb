class CommunitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_community, only: [:show, :edit, :update, :destroy, :dashboard]

  def index
    @communities = policy_scope(Community)
  end

  def show
    authorize @community
    @events = @community.events
    @join_request = CommunityJoinRequest.new
    @community_user = CommunityUser.new
  end

  def new
    @community = Community.new
    authorize @community
  end

  def create
    @community = Community.new(community_params)
    @community.user = current_user
    authorize @community

    if @community.save!
      @community.community_users.create!(user: current_user, role: "admin", community: @community)
      redirect_to community_path(@community), notice: 'Community was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @community
  end

  def update
    @community.update!(community_params)
    redirect_to community_path(@community)
    authorize @community
  end

  def destroy
    @community.destroy!
    redirect_to communities_path, status: :see_other
    authorize @community
  end

  def dashboard
    authorize @community
    @events = @community.events
    @join_requests = @community.community_join_requests
    @community_users = @community.community_users
  end

  def my_communities
    @my_communities = current_user.communities
    authorize @my_communities
  end

  def events_owned
    @events_owned = current_user.events
    authorize @events_owned
  end

  private

  def community_params
    params.require(:community).permit(:title, :description, :category, :country, :city, :public, :is_visible, :video, photos: [])
  end

  def set_community
    @community = Community.find(params[:id])
  end
end
