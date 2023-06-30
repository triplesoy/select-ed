class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :show, :destroy, :event_dashboard]
  before_action :set_community, only: [:index, :show, :destroy, :edit, :update]
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
    @event = Event.new(event_params)
    @event.community = Community.friendly.find(params[:community_id])
    @community = Community.friendly.find(params[:community_id])
    @event.user = current_user
    if @event.save
      @event.update(start_time: @event.start_time.to_datetime.in_time_zone("America/Mexico_City"))
      @event.update(end_time: @event.end_time.to_datetime.in_time_zone("America/Mexico_City"))
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

    event_params = params.require(:event).permit(:title, :description, :address, :start_time, :end_time)

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
