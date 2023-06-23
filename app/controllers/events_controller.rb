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
    @events = Event.where(id: params[:id])
    @ticket = Ticket.where(id: params[:id])
    #@tickets = @events.tickets
    @markers = @events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude
      }
    end
    authorize @event
    unless @event.user == current_user
      # redirect_to communities_path, status: :see_other, alert: "You are not authorized to see this booking"

    end

    #@ticket = @event.ticket
    #@user_ticket = @event.ticket.user_ticket

  end


  def new
    @community = Community.find(params[:community_id])
    @event = Event.new(community: @community)
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    @event.community = Community.find(params[:community_id])
    @community = Community.find(params[:community_id])
    @event.user = current_user
    if @event.save!
      @event.update(start_time: @event.start_time.to_datetime.in_time_zone("America/Mexico_City"))
      @event.update(end_time: @event.end_time.to_datetime.in_time_zone("America/Mexico_City"))
      redirect_to new_community_event_ticket_path(@community, @event)
    end
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
    @event = Event.find(params[:id])
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
    @event = Event.find(params[:id])
  end

end
