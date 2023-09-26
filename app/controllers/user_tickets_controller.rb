class UserTicketsController < ApplicationController
  before_action :set_ticket, only: [:edit, :update, :show, :new, :create, :update, :checkout]
  before_action :set_user_ticket, only: [:edit, :update, :show, :destroy, :confirmation, :validation]
  skip_after_action :verify_authorized, only: [:cancel]



  def index
  end

  def show
    @community = @ticket.event.community

    @event = @ticket.event
    authorize @user_ticket

    @markers = [
      {
        lat: @event.latitude,
        lng: @event.longitude
      }
    ]
  end

  def new
    @user_ticket = UserTicket.new(ticket: @ticket)
    authorize @user_ticket
  end

  # user_tickets_controller.rb

  def checkout
    @user_ticket = UserTicket.new(ticket: @ticket)
    authorize @user_ticket

    begin
      @session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price: @ticket.stripe_price_id,
          quantity: 1,
        }],
        mode: 'payment',
        success_url: payment_success_user_tickets_url(ticket_id: @ticket.id),
        cancel_url: cancel_user_tickets_url,
        customer_email: current_user.email, # Add this line to prefill the email

        metadata: {
          user_ticket_id: @user_ticket.id,
          ticket_id: @ticket.id,
        }
      })

      stripe_session_id = @session.id

      # Log the Stripe session ID to the server logs
      Rails.logger.info "Stripe session ID: #{stripe_session_id}"

      # Store the Stripe session ID in the session for later use
session[:stripe_session_id] = stripe_session_id

      redirect_to @session.url, allow_other_host: true
    rescue => e
      # Log the error to the server logs
      Rails.logger.error "Error during checkout: #{e.message}"

      redirect_to root_path, alert: "There was an error with the checkout process: #{e.message}"
    end
  end

def payment_success
  # Get ticket_id from params and find the corresponding ticket
  ticket_id = params[:ticket_id]
  @ticket = Ticket.find(ticket_id)
  # Now you can proceed to create the UserTicket just like you do for free tickets
  create
end

def create
  @user_ticket = UserTicket.new(ticket: @ticket, processed: false)
  @user_ticket.user = current_user
  authorize @user_ticket

  if @user_ticket.save
    @ticket.update(quantity: @ticket.quantity - 1)
    TicketProcessingWorker.perform_async(@user_ticket.id, session[:stripe_session_id])
    redirect_to confirmation_page_path(@user_ticket)
  else
    render json: { error: @user_ticket.errors.full_messages }, status: :unprocessable_entity
  end
end





# app/controllers/user_tickets_controller.rb
def cancel
  @ticket = Ticket.find_by(id: params[:id])

  if @ticket.nil?
    redirect_to root_path, alert: 'Payment canceled'
    return
  end

  authorize @ticket
  # ... (Rest of your code)
end



def edit
end

def update
  authorize @user_ticket
  if @user_ticket.scanned == "pending"
    @user_ticket.update!(scanned: params[:scanned])
    redirect_to :new_scan, alert: "Ticket marked as #{params[:scanned]}!"
  elsif @user_ticket.scanned == "rejected"
    @user_ticket.update!(scanned: params[:scanned])
    redirect_to :new_scan, alert: "Ticket marked as #{params[:scanned]}!"
  else
    @user_ticket.update!(scanned: params[:scanned])
    redirect_to :new_scan, alert: "Ticket marked as #{params[:scanned]}!"
  end
end

  def destroy
    @user_ticket.destroy
    redirect_to community_path(@ticket.event.community), status: :see_other
    authorize @user_ticket
  end

  def confirmation
    @ticket = @user_ticket.ticket
    @event = @ticket.event
    @user = @user_ticket.user
    authorize @user_ticket

    if @ticket.model == 'regular'  # or any other criteria to determine it's a paid ticket
      @stripe_session = Stripe::Checkout::Session.retrieve(session[:stripe_session_id])
    else
      @stripe_session = nil
    end

    @markers = [
      {
        lat: @event.latitude,
        lng: @event.longitude
      }
    ]
  end

  def validation
    @user = @user_ticket.user
    @event = @user_ticket.ticket.event
    @user_ticket_name = @user_ticket.user.full_name

    authorize @user_ticket
  end

  def my_user_tickets
    @user = current_user
    @my_user_tickets = @user.user_tickets

    if @my_user_tickets.empty?
      flash[:notice] = "You haven't purchased any tickets yet!"
      redirect_to root_path
    else
      @my_user_tickets.each { |user_ticket| authorize user_ticket }
    end

    authorize @my_user_tickets
  end

  def new_scan
    @user_ticket = UserTicket.new()
    authorize @user_ticket
  end

# existing check_processed method in your controller
def check_processed
  if params[:id].present? && params[:id] != "undefined"
    @user_ticket = UserTicket.find_by(id: params[:id])
    if @user_ticket
      authorize @user_ticket
      render json: { processed: @user_ticket.processed }
    else
      skip_authorization
      render json: { error: 'UserTicket not found' }, status: :not_found
    end
  else
    skip_authorization
    render json: { error: 'Invalid ID' }, status: :bad_request
  end
end


  private

  def set_user_ticket
    @user_ticket = UserTicket.find(params[:id])
  end

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def limit_image_size(image_path, max_size)
    image = MiniMagick::Image.open(image_path)
    image.quality("85%")
    image.strip
    image.combine_options do |c|
      c.resize "50%"
    end
    image.write(image_path)

    while File.size(image_path) > max_size.kilobytes
      image.combine_options do |c|
        c.resize "90%"
      end
      image.write(image_path)
    end
  end


  def user_ticket_params
    params.require(:user_ticket).permit(:scanned)
  end


end
