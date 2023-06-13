class CommunitiesController < ApplicationController
before_action :set_community, only: [:show, :edit, :update, :destroy]

  def index
    @communities = policy_scope(Community)
  end

  def show
  end

  def new
    @community = Community.new
    authorize @community
    
  end

  def create
    @community = Community.new(community_params)
    @community.user = current_user
    if @community.save
      redirect_to community_path(@communities)
    else
      render :new, status: :unprocessable_entity
    end
    authorize @community
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def community_params
    params.require(:community).permit(:title, :description, :category, :country, :city, :is_public, :is_visible)
  end

  def set_community
    @community = Community.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:id])
  end

end
