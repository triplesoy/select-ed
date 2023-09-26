class CommunitiesController < ApplicationController
  require 'countries'

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_community, only: [:show, :edit, :update, :destroy, :dashboard]

  def index
    @communities = policy_scope(Community).all
    # @communities = Community.all
  end

  def show
    authorize @community
    @events = @community.events
    @join_request = CommunityJoinRequest.new
    @community_user = CommunityUser.new
    @average_age = @community.members.average('EXTRACT(YEAR FROM AGE(birthdate))')&.round
    @average_age = @average_age ? @average_age.round : nil
    @average_age = @average_age.to_i if @average_age
    @average_age = 0 if @average_age.nil?
    @average_age = 100 if @average_age > 100
    @average_age = 0 if @average_age < 0



    if current_user
      @my_events = current_user.events_going_to
      @communities = current_user.owned_communities
    end


    # if current_user.nil?
    #   redirect_to new_user_session_path
    # else
    #   render :show
    # end
  end

  def new
    @community = Community.new
    authorize @community
  end

  def create
    @community = Community.new(community_params)
    @community.community_owner = current_user
    authorize @community

    if @community.save
      @community.community_users.create(user: current_user, role: "admin")
      redirect_to community_path(@community), notice: 'Community was successfully created.'
    else
      respond_to do |format|
      format.html { render :new }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@community, partial: 'communities/form', locals: { community: @community })
      end
    end
  end
end



  def edit
    authorize @community
  end

  def update
    @community = Community.find_by(slug: params[:id])
    authorize @community

    community_params = params.require(:community).permit(:title, :description, :short_description, :category, :country, :city, :public, :is_visible, :video, :youtube_banner, photos: [], photos_delete: [])

    if params[:community][:photos].present?
      @community.photos.attach(params[:community][:photos])
    end

    if @community.update(community_params.except(:photos))
      redirect_to community_path(@community), notice: "Community was successfully updated."
    else
      flash[:alert] = @community.errors.full_messages.join(", ")
      render :edit
    end
  end



  def destroy
    @community.destroy!
    redirect_to communities_path, status: :see_other
    authorize @community
  end

  def destroy_community_photo
    @community = Community.find(params[:community_id])
    authorize @community
    @attachment = ActiveStorage::Attachment.find(params[:photo_id])
    @attachment.purge
    redirect_to edit_community_path(@community)
  end

  def dashboard
    authorize @community
    @events = @community.events
    @join_requests = @community.community_join_requests
    @community_users = @community.community_users
  end

  def my_communities
    @my_communities = current_user.communities

    if @my_communities.empty?
      flash[:notice] = "You haven't joined any communities yet!"
      redirect_to root_path
    else
      @my_communities.each { |community| authorize community }
    end

    authorize @my_communities
  end


  def events_owned
    @events_owned = current_user.events
    authorize @events_owned
  end

  private


  def community_params
    params.require(:community).permit(:title, :description, :short_description, :category, :country, :instagram_handle_main, :instagram_handle_members, :city, :public, :youtube_banner, :is_visible, :video, photos: [], photos_delete: [])
  end

  def set_community
    @community = Community.friendly.find(params[:id])
  end
end
