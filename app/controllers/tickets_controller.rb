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
    @community = Community.find(params[:community_id])
    @free_quantity = params["ticket_details"]["free"]["quantity"]
    @regular_quantity = params["ticket_details"]["regular"]["quantity"]
    @regular_price = params["ticket_details"]["regular"]["price"]
    @vip_quantity = params["ticket_details"]["vip"]["quantity"]
    @vip_r_code = params["ticket_details"]["vip"]["r_code"]

    @event = Event.find(params[:event_id])

    @free_ticket = Ticket.new(event: @event, model: "free", quantity: @free_quantity, price: 0)
    @regular_ticket = Ticket.new(event: @event, model: "regular", quantity: @regular_quantity, price: @regular_price)
    @vip_ticket = Ticket.new(event: @event, model: "vip", quantity: @vip_quantity, price: 0, r_code: @vip_r_code)

    if @free_ticket.save && @regular_ticket.save && @vip_ticket.save
      redirect_to community_path(@community), alert: "You have successfully created the event!"
    else
      render :new, status: :unprocessable_entity
    end

    authorize @free_ticket
    authorize @regular_ticket
    authorize @vip_ticket
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
