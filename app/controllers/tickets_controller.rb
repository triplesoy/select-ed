class TicketsController < ApplicationController
  before_action :set_event, only: [:new, :create, :show, :destroy]
  before_action :set_ticket, only: [:show, :destroy]

  def index
  end

  def show
  end

  def new

    @ticket = Ticket.new(event: @event)
    authorize @ticket
  end

  def create
    @community = Community.find_by(slug: params[:community_id])
    @free_quantity = params["ticket_details"]["free"]["quantity"]
    @regular_quantity = params["ticket_details"]["regular"]["quantity"]
    @regular_price = params["ticket_details"]["regular"]["price"]
    @vip_quantity = params["ticket_details"]["vip"]["quantity"]
    @vip_r_code = params["ticket_details"]["vip"]["r_code"]



    @free_ticket = Ticket.new(event: @event, model: "free", quantity: @free_quantity, price: 0)
    @regular_ticket = Ticket.new(event: @event, model: "regular", quantity: @regular_quantity, price: @regular_price)
    @vip_ticket = Ticket.new(event: @event, model: "vip", quantity: @vip_quantity, price: 0, r_code: @vip_r_code)

    if @free_ticket.save && @regular_ticket.save && @vip_ticket.save
      redirect_to community_path(@community), alert: "You have successfully created the event!"
    else
      render :new, status: :unprocessable_entity, alert: "Failed to create the tickets."
    end

    authorize @free_ticket
    authorize @regular_ticket
    authorize @vip_ticket
  end

  def edit
    @ticket = Ticket.find(params[:id])
    authorize @ticket
   # @ticket.each { |ticket| authorize ticket }
  end

  def update
    @ticket = Ticket.find(params[:id])
    @event = @ticket.event
    @ticket.update(ticket_params)
    authorize @ticket
    redirect_to event_dashboard_path(@event.community, @event), notice: "You have successfully updated the tickets!"
  end

  def destroy
    @ticket.destroy
    redirect_to community_path(@community), status: :see_other
    authorize @ticket
  end


  private

  def ticket_params
    params.require(:ticket).permit(:quantity, :r_code, :price)
  end

  def set_event
    @event = Event.friendly.find(params[:event_id])

  end

  def set_ticket
    @ticket = @event.tickets
  end
end
