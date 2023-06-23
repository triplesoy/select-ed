class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :show, :destroy, :event_dashboard]
  before_action :set_community, only: [:index, :show, :destroy, :edit, :update]

  def index
    @events = policy_scope(Event)
    @markers = @events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude
      }
    end
  end

  def show
    @ticket = Ticket.find_by(id: params[:id])
    @markers = [{
      lat: @event.latitude,
      lng: @event.longitude
    }]
    authorize @event

    unless @event.user == current_user
      # Redirect or handle unauthorized access here
    end
  end


  def new
    @community = Community.friendly.find(params[:community_id])
    @event = Event.new(community: @community)
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    @event.community = Community.friendly.find(params[:community_id])
    @community = Community.friendly.find(params[:community_id])
    @event.user = current_user
    redirect_to new_community_event_ticket_path(@community, @event) if @event.save!
    authorize @event
  end

  def edit
    authorize @event
  end

  def update
    @event.update!(event_params)
    redirect_to community_event_path(@community, @event)
    authorize @event
  end

  def destroy
    @event.destroy
    redirect_to community_path(@community), status: :see_other
    authorize @event
  end

  def my_events
    @my_events = current_user.events_going_to
    @my_events.each { |event| authorize event}
  end

  def events_owned
    @events_owned = current_user.events
    authorize @events_owned
  end

  def event_dashboard
    authorize @event
    @event = Event.friendly.find(params[:id])
    @tickets = @event.tickets
  end






  private

  def event_params
    params.require(:event).permit(:title, :start_time, :end_time, :address, :description, :price, :capacity, photos: [])
  end

  def set_community
    @community = @event.community
  end

  def set_event
    @event = Event.friendly.find(params[:id])
  end

end
