class EventsRsvpController < ApplicationController
  before_action :set_event, only: [:edit, :update, :show, :destroy]
  before_action :set_event_rsvp, only: [:edit, :update, :show, :destroy]

  def index
  end

  def show
  end

  def new
    @event = Event.find(params[:event_id])
    @event_rsvp = EventRsvp.new(event: @event)
    authorize @event_rsvp
  end

  def create
    raise
    @event_rsvp = EventRsvp.new(event_rsvp_params)
    @event_rsvp.user = current_user
    redirect_to communities_path if @event_rsvp.save!
    #community_event_path(@community, @event) if @event_rsvp.save!
    authorize @event_rsvp
  end

  def edit
  end

  def update
  end

  def destroy
    @event_rsvp.destroy
    redirect_to community_path(@community), status: :see_other
    authorize @event_rsvp
  end

  private

  def event_rsvp_params
    params.require(:event).permit(:user_id, :event_id, :status)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def set_event_rsvp
    @event = EventRsvp.find(params[:id])
  end

end
