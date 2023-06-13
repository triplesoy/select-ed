class CommunitiesController < ApplicationController
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

  def community_params
    params.require(:community).permit(:title, :description, :country, :city, :is_public, :is_visible)
  end

  def set_community
    @community = Community.find_by(id: params[:id])
  end

  def set_event
    @event = Event.find(params[:id])
  end

end
