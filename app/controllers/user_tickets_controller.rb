class UserTicketsController < ApplicationController
  include ManualQrCodeGenerator


  before_action :set_ticket, only: [:edit, :update, :show, :new, :create, :update, :checkout]
  before_action :set_user_ticket, only: [:edit, :update, :show, :destroy, :confirmation, :validation, :confirmation_manual ]
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

  @ticket.update(quantity: @ticket.quantity - 1)


end


def manual_new
  @community = Community.find_by!(slug: params[:community_id])
  @available_tickets = Ticket.joins(:event)
    .where('events.end_time > ? AND events.id IN (?)',
    Time.use_zone("America/Mexico_City") { Time.zone.yesterday },
    @community.events.pluck(:id))
    .where.not(model: 'regular')

  @user_ticket = UserTicket.new
  authorize @user_ticket
end


def manual_create
  puts "PARAMS: #{params.inspect}"

  # Separate :qr_full_name and :qr_email from user_ticket_params
  ticket_params = user_ticket_params.except(:qr_full_name, :qr_email, :ticket_id)

  # Initialize @user_ticket without :qr_full_name and :qr_email
  @user_ticket = UserTicket.new(ticket_params.merge(processed: false))

  @user_ticket.ticket = Ticket.find(params[:user_ticket][:ticket_id]) if params[:user_ticket][:ticket_id].present?


  # Handle :qr_full_name and :qr_email separately
  @qr_email = params[:user_ticket][:qr_email]
  @qr_full_name = params[:user_ticket][:qr_full_name]



  session[:qr_email] = @qr_email
  session[:qr_full_name] = @qr_full_name

   # Validate qr_full_name and qr_email before attempting to save the user_ticket.
   if @qr_full_name.blank? || !@qr_full_name.match(/\A[a-zA-Z ]+\z/) || @qr_full_name.length > 50
    @user_ticket.errors.add(:qr_full_name, "is invalid")
  end

  if @qr_email.present? && !URI::MailTo::EMAIL_REGEXP.match(@qr_email)
    @user_ticket.errors.add(:qr_email, "is invalid")
  end

  authorize @user_ticket

  if @user_ticket.errors.empty? && @user_ticket.save

link = validation_page_url(ticket_id: @user_ticket.ticket.id, id: @user_ticket.id)
    png = QrCodeService.new(link).generate

    composite_image_path = ManualImageService.new(png, @user_ticket.ticket.event, @user_ticket.ticket.event.community, @qr_full_name, @user_ticket).composite_image

    @user_ticket.qrcode.attach(io: File.open(composite_image_path), filename: "qr_code.png", content_type: "image/png")
    @user_ticket.update!(processed: true)

    send_email if params[:user_ticket][:qr_email].present?
    redirect_to confirmation_manual_page_path(@user_ticket), alert: "You have successfully purchased a ticket!"
  else
    @qr_full_name = @qr_full_name  # setting instance variable for the view
    @qr_email = @qr_email  # setting instance variable for the view

    @community = Community.find_by!(slug: params[:community_id])
    @available_tickets = Ticket.joins(:event)
      .where('events.end_time > ? AND events.id IN (?)',
      Time.use_zone("America/Mexico_City") { Time.zone.yesterday },
      @community.events.pluck(:id))
      .where.not(model: 'regular')

    respond_to do |format|
    format.html { render :new }
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(@user_ticket, partial: 'user_tickets/form', locals: { user_ticket: @user_ticket })
    end
  end
  end
end



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


  def confirmation_manual
    @ticket = @user_ticket.ticket
    @event = @ticket.event
    @community = @ticket.event.community

    @user = @user_ticket.user

    @qr_email = session[:qr_email]
    @qr_full_name = session[:qr_full_name]

      # Clearing session after use
  session.delete(:qr_email)
  session.delete(:qr_full_name)


    authorize @user_ticket
  end




  def validation
    @user = @user_ticket.user
    @event = @user_ticket.ticket.event

    @user_ticket_name = @user&.full_name

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

  def send_email
    UserTicketMailer.with(user: @user_ticket.user, user_ticket: @user_ticket, qr_email: @qr_email, qr_full_name: @qr_full_name).send_ticket.deliver_now
  end

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
    params.require(:user_ticket).permit(:scanned, :qr_full_name, :qr_email, :ticket_id)
  end


end
