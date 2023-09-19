class TicketsController < ApplicationController
  before_action :set_event, only: [:new, :create, :show, :destroy]
  before_action :set_tickets, only: [:show]

  def index
  end

  def show

  end

  def new
    @ticket = Ticket.new(event: @event)

    authorize @ticket
  end

#   def create
#     @community = Community.find_by(slug: params[:community_id])
#     tickets_to_save = []

#     # Create Free ticket if quantity is present
#     if params["ticket_details"]["free"]["quantity"].to_i > 0
#       @free_ticket = Ticket.new(event: @event, model: "free", price: 0)
#       @free_ticket.quantity = params["ticket_details"]["free"]["quantity"].to_i
#       @free_ticket.expire_time = local_to_utc(params["ticket_details"]["free"]["expire_time"]) if params["ticket_details"]["free"]["expire_time"].present?
#       authorize @free_ticket
#       tickets_to_save << @free_ticket
#     end

#     # Create Regular ticket if quantity is present
#     if params["ticket_details"]["regular"] && params["ticket_details"]["regular"]["quantity"].to_i > 0
#       @regular_ticket = Ticket.new(event: @event, model: "regular")
#       @regular_ticket.quantity = params["ticket_details"]["regular"]["quantity"].to_i
#       @regular_ticket.price = params["ticket_details"]["regular"]["price"].to_i # Ensure price is set
#       authorize @regular_ticket
#   # Create a Stripe Price object
#   stripe_product = Stripe::Product.create(name: "Regular Ticket for #{@event.title}")
#   stripe_price = Stripe::Price.create(
#     product: stripe_product.id,
#     unit_amount: @regular_ticket.price * 100, # Stripe uses cents, so multiply by 100
#     currency: 'mxn' # or your preferred currency
#   )

#   @regular_ticket.stripe_price_id = stripe_price.id
#   tickets_to_save << @regular_ticket
# end

#     # Create VIP ticket if quantity is present
#     if params["ticket_details"]["vip"]["quantity"].to_i > 0
#       @vip_ticket = Ticket.new(event: @event, model: "vip", price: 0)
#       @vip_ticket.quantity = params["ticket_details"]["vip"]["quantity"].to_i
#       @vip_ticket.r_code = params["ticket_details"]["vip"]["r_code"]
#       authorize @vip_ticket
#       tickets_to_save << @vip_ticket
#     end

#     # Now save all tickets
#     if tickets_to_save.all?(&:save)
#       redirect_to community_path(@community), alert: "You have successfully created the event!"
#     else
#       render :new, status: :unprocessable_entity, alert: "Failed to create the event."
#     end
#   end



#   def edit
#     @ticket = Ticket.find(params[:id])
#     authorize @ticket

#   end

#   def update
#     @ticket = Ticket.find(params[:id])
#     @event = @ticket.event
#     @ticket.update(ticket_params)
#     authorize @ticket
#     redirect_to event_dashboard_path(@event.community, @event), notice: "You have successfully updated the tickets!"
#   end


  def create
    @community = Community.find_by(slug: params[:community_id])
    tickets_to_save = []

    if params["ticket_details"]["free"]["quantity"].to_i > 0
      @free_ticket = Ticket.new(event: @event, model: "free", price: 0)
      set_ticket_attributes(@free_ticket, params["ticket_details"]["free"])
      authorize @free_ticket
      tickets_to_save << @free_ticket
    end

    if params["ticket_details"]["regular"] && params["ticket_details"]["regular"]["quantity"].to_i > 0
      @regular_ticket = Ticket.new(event: @event, model: "regular")
      set_ticket_attributes(@regular_ticket, params["ticket_details"]["regular"])
      authorize @regular_ticket
  # Create a Stripe Price object
  stripe_product = Stripe::Product.create(name: "Regular Ticket for #{@event.title}")
  stripe_price = Stripe::Price.create(
    product: stripe_product.id,
    unit_amount: @regular_ticket.price * 100, # Stripe uses cents, so multiply by 100
    currency: 'mxn' # or your preferred currency
  )

  @regular_ticket.stripe_price_id = stripe_price.id
      tickets_to_save << @regular_ticket
    end

    if params["ticket_details"]["vip"]["quantity"].to_i > 0
      @vip_ticket = Ticket.new(event: @event, model: "vip", price: 0)
      set_ticket_attributes(@vip_ticket, params["ticket_details"]["vip"])
      authorize @vip_ticket
      tickets_to_save << @vip_ticket
    end

    if tickets_to_save.all?(&:save)
      redirect_to community_path(@community), alert: "You have successfully created the event!"
    else
      render :new, status: :unprocessable_entity, alert: "Failed to create the event."
    end
  end

  def edit
    @ticket = Ticket.find(params[:id])
    @event = @ticket.event
    authorize @ticket
  end

  def update
    @ticket = Ticket.find(params[:id])
    @event = @ticket.event
    set_ticket_attributes(@ticket, ticket_params)
    authorize @ticket

    # Update Stripe Price if it's a regular ticket
    if @ticket.model == "regular"
      begin
        stripe_product = Stripe::Product.create(name: "Regular Ticket for #{@event.title}")
        stripe_price = Stripe::Price.create(
          product: stripe_product.id,
          unit_amount: @ticket.price * 100, # Stripe uses cents, so multiply by 100
          currency: 'mxn' # or your preferred currency
        )
        @ticket.stripe_price_id = stripe_price.id
      rescue Stripe::StripeError => e
        # Handle Stripe errors (e.g., Price not found)
        flash[:alert] = "Stripe error: #{e.message}"
        render :edit, status: :unprocessable_entity and return
      end
    end

    if @ticket.save
      redirect_to event_dashboard_path(@event.community, @event), notice: "You have successfully updated the tickets!"
    else
      render :edit, status: :unprocessable_entity, alert: "Failed to update the ticket."
    end
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

  private

  def set_ticket_attributes(ticket, attributes)
    ticket.quantity = attributes["quantity"].to_i
    ticket.price = attributes["price"].to_i if attributes["price"]
    ticket.expire_time = local_to_utc(attributes["expire_time"]) if attributes["expire_time"].present?
    ticket.r_code = attributes["r_code"] if attributes["r_code"]
  end

  def ticket_params
    params.require(:ticket).permit(:quantity, :r_code, :price, :expire_time)
  end

  def set_event
    @event = Event.friendly.find(params[:event_id])
  end

  def set_tickets
    @regular_ticket = @event.tickets.find_by(model: 'regular')
    @free_ticket = @event.tickets.find_by(model: 'free')
    @vip_ticket = @event.tickets.find_by(model: 'vip')
  end

  def local_to_utc(local_time_string)
    Time.use_zone('Mexico City') do
      local_time = Time.zone.parse(local_time_string)
      local_time.utc
    end
  end

end
