class TicketsController < ApplicationController
  before_action :set_event, only: [:show, :destroy]
  before_action :set_ticket, only: [:show, :destroy]

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
    @event = Event.find(params[:event_id])

    @free_ticket = Ticket.new(event: @event, model: "free", price: 0)
    @regular_ticket = Ticket.new(event: @event, model: "regular")
    @vip_ticket = Ticket.new(event: @event, model: "vip", price: 0)

    @free_ticket.quantity = params["ticket_details"]["free"]["quantity"]
    @free_ticket.expire_time = params["ticket_details"]["free"]["expire_time"]
    @regular_ticket.quantity = params["ticket_details"]["regular"]["quantity"]
    @regular_ticket.price = params["ticket_details"]["regular"]["price"]
    @vip_ticket.quantity = params["ticket_details"]["vip"]["quantity"]
    @vip_ticket.r_code = params["ticket_details"]["vip"]["r_code"]

    authorize @free_ticket
    authorize @regular_ticket
    authorize @vip_ticket

    if @free_ticket.save && @regular_ticket.save && @vip_ticket.save
      @free_ticket.expire_time = @free_ticket.expire_time.to_datetime.in_time_zone("America/Mexico_City")
      redirect_to community_path(@community), alert: "You have successfully created the event!"
    else
      render :new, status: :unprocessable_entity, alert: "Failed to create the event."
    end
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

  def redeem
    @ticket = Ticket.find(params[:id])
    authorize @ticket
    if params[:code] == @ticket.r_code
      respond_to do |format|
        format.json { render json: { code: @ticket.r_code } }
      end
    else
      respond_to do |format|
        format.json { render json: { error: "wrong code" } }
      end
    end
  end


  # def counter
  # @acc_counter = 0
  # @rej_counter = 0
  # @event.ticekts do |ticket|
  # if ticket.user_ticket.scanned == 'rejected'
  #   @rej_counter += 1
  #   elsif == 'pending'

  #   elsif == accepted
  #     @acc_counter += 1
  # end
  # [ac_counter, rej_counter]

  # @accepted = counter[0]
  # @rejected = counter[1]
  # end

  private

  def ticket_params
    params.require(:ticket).permit(:quantity, :r_code, :price, :expire_time)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def set_ticket
    @ticket = @event.tickets
  end
end
