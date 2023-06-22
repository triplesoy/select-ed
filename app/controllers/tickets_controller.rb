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
      render :new, status: :unprocessable_entity, alert: "Failed to create the tickets."
    end

    authorize @free_ticket
    authorize @regular_ticket
    authorize @vip_ticket
  end

  def edit
    @community = @event.community
    # authorize @ticket
    @ticket.each { |ticket| authorize ticket }
  end

  def update
    @free_ticket  = @event.tickets.find_by(model: 'free')
    @free_ticket.update(quantity: params["ticket_details"]["free"]["quantity"].to_i)
    @vip_ticket     = @event.tickets.find_by(model: 'vip')
    @vip_ticket.update(quantity: params["ticket_details"]["vip"]["quantity"].to_i)
    @regular_ticket = @event.tickets.find_by(model: 'regular')
    @regular_ticket.update(quantity: params["ticket_details"]["regular"]["quantity"].to_i)
    authorize @free_ticket
    authorize @regular_ticket
    authorize @vip_ticket
    redirect_to community_event_path(@event.community, @event), notice: "You have successfully updated the tickets!"
  end

  def destroy
    @ticket.destroy
    redirect_to community_path(@community), status: :see_other
    authorize @ticket
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
    params.require(:event).permit(:user_id, :event_id, :status, :price, :quantity)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def set_ticket
    @ticket = @event.tickets
  end
end
