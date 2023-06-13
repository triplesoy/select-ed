class EventsController < ApplicationController
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

  def event_params
    params.require(:event).permit(:title, :start_date, :end_date, :address, :description, :price, :capacity)
  end

  def set_community
    @community = Community.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
