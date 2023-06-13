class EventsController < ApplicationController
  before_action :set_event, only: [:new, :create, :edit, :update, :show, :total_price]
  before_action :set_community, only: [:index, :show, :destroy, :edit, :update]

  def index
    @events = policy_scope(Event)
  end

  def show
    authorize @event
      unless @event.user == current_user
     # redirect_to communities_path, status: :see_other, alert: "You are not authorized to see this booking"
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.community = Venue.find(params[:venue_id])
    @event.user = current_user
    @event.save!
  end

  def edit
    authorize @event
  end

  def update
    authorize @event
    @event.update(event_params)
    redirect_to event_path(@event)
  end

  def destroy
    authorize @event
    @event.destroy
    redirect_to community_events_path, status: :see_other
  end

  def my_events
    @my_events = current_user.events
  end

  private

  def event_params
    params.require(:event).permit(:title, :start_date, :end_date, :address, :description, :price, :capacity)
  end

  def set_community
    @community = Community.find(params[:community_id])
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
