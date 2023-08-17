class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :show, :destroy, :event_dashboard]
  before_action :set_community, only: [:index, :show, :destroy, :edit, :update]
  before_action :set_ticket, only: [:show]
  helper_method :user_has_dashboard_access?


  skip_after_action :verify_authorized, only: :my_events

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
    authorize @event
    @event = Event.friendly.find(params[:id])
    @regular_ticket = @event.tickets.find_by(model: 'regular')
    @free_ticket = @event.tickets.find_by(model: 'free')
    @vip_ticket = @event.tickets.find_by(model: 'vip')
    @markers = [{
      lat: @event.latitude,
      lng: @event.longitude
    }]
    @user = current_user
    @user_ticket = @event.user_tickets.each do |user_ticket|
      if user_ticket.user_id == @user.id
        @user_ticket = user_ticket
      end
      return @user_ticket

    end



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
    @community = Community.friendly.find(params[:community_id])
    @event = Event.new(event_params.except(:start_time, :end_time)) # remove start and end time from event_params
    @event.community = @community
    @event.user = current_user

    # parse start_time and end_time as Mexico City time, then convert to UTC
    start_time = ActiveSupport::TimeZone['America/Mexico_City'].parse(event_params[:start_time]).utc
    end_time = ActiveSupport::TimeZone['America/Mexico_City'].parse(event_params[:end_time]).utc

    @event.start_time = start_time
    @event.end_time = end_time

    if @event.save
      redirect_to new_community_event_ticket_path(@community, @event)
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@event, partial: 'events/form', locals: { event: @event })
        end
      end
    end

    authorize @event
  end



  def edit
    authorize @event
  end

def update
  @event = Event.find_by(slug: params[:id])

  # parse start_time and end_time as Mexico City time, then convert to UTC
  start_time = ActiveSupport::TimeZone['America/Mexico_City'].parse(params[:event][:start_time]).utc if params[:event][:start_time].present?
  end_time = ActiveSupport::TimeZone['America/Mexico_City'].parse(params[:event][:end_time]).utc if params[:event][:end_time].present?

  event_params = params.require(:event).permit(:title, :description, :address)
  event_params[:start_time] = start_time if start_time.present?
  event_params[:end_time] = end_time if end_time.present?

  if params[:event][:photos].present?
    @event.photos.attach(params[:event][:photos])
  end

  if @event.update(event_params)
    redirect_to community_event_path(@event.community, @event), notice: "Event was successfully updated."
  else
    render :edit
  end

  authorize @event
end

  def destroy
    @event.destroy
    redirect_to community_path(@community), status: :see_other
    authorize @event
  end

  def destroy_event_photo
    @event = Event.find(params[:event_id])
    authorize @event
    @attachment = ActiveStorage::Attachment.find(params[:photo_id])
    @attachment.purge
    redirect_to edit_community_event_path(@event.community, @event)
  end

  def my_events
    @my_events = current_user.events_going_to

    if @my_events.empty?
      flash[:notice] = "You have no upcoming events."
      redirect_to root_path
    else
      @my_events.each { |event| authorize event }
    end
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


  def user_has_dashboard_access?
    @community.owner == current_user ||
    (current_user && current_user.is_moderator_of?(@community)) ||
    (current_user && current_user.admin)
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

  def set_ticket
    @ticket = @event.tickets
  end


end
