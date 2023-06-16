class TicketsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :show, :destroy]
  before_action :set_ticket, only: [:edit, :update, :show, :destroy]

  def index
  end

  def show
  end

  def new
    @event = Event.find(params[:event_id])
    @ticket = Ticket.new(event: @event)
    authorize @ticket
  end

  def create
    raise
    @event = Event.find(params[:event_id])
    @ticket = Ticket.new(event: @event)
    @ticket.user = current_user
    if @ticket.save
      redirect_to "/events/show", alert: "You have successfully joined the event!"
    else
      redirect_to "/event/show", alert: "Failed to join the event."
    end

    authorize @ticket
  end

  def edit
  end

  def update
  end

  def destroy
    @ticket.destroy
    redirect_to community_path(@community), status: :see_other
    authorize @ticket
  end

  private

  def ticket_params
    params.require(:event).permit(:user_id, :event_id, :status)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def set_ticket
    @event = EventRsvp.find(params[:id])
  end

end
