class CommunitiesController < ApplicationController
skip_before_action :authenticate_user!, only: [:index, :show]
before_action :set_community, only: [:show, :edit, :update, :destroy]

  def index
    @communities = policy_scope(Community)
  end

  def show
    authorize @community
  end

  def new
    @community = Community.new
    authorize @community
  end

  def create
    @community = Community.new(community_params)
    if @community.save
      redirect_to community_path(@community)
    else
      render :new, status: :unprocessable_entity
    end
    authorize @community
  end

  def edit
    authorize @community
  end

  def update
    @community.update(community_params)
    redirect_to community_path(@community)
    authorize @community
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
