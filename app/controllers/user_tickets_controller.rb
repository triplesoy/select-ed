class UserTicketsController < ApplicationController
  before_action :set_ticket, only: [:edit, :update, :show, :new, :create, :update]
  before_action :set_user_ticket, only: [:edit, :update, :show, :destroy, :confirmation, :validation]

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

  def create
    @user_ticket = UserTicket.new(ticket: @ticket)
    @user_ticket.user = current_user
    authorize @user_ticket

    if @user_ticket.save!
      @ticket.update(quantity: @ticket.quantity - 1)

      link = validation_page_url(ticket_id: @ticket.id, id: @user_ticket.id)
      png = QrCodeService.new(link).generate

      composite_image_path = ImageService.new(png, @ticket.event, @ticket.event.community, current_user, @user_ticket).composite_image

      @user_ticket.qrcode.attach(io: File.open(composite_image_path), filename: "qr_code.png", content_type: "image/png")

      UserTicketMailer.with(user: @user_ticket.user, user_ticket: @user_ticket).send_ticket.deliver_now
      redirect_to confirmation_page_path(@user_ticket), alert: "You have successfully purchased a ticket!"
    else
      render :new, status: :unprocessable_entity, alert: "Failed to buy the tickets."
    end
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
    authorize @user_ticket

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

  private

  def set_user_ticket
    puts "User Ticket ID: #{params[:id]}"
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

  def formatted_start_time
    @event.start_time.in_time_zone("America/Mexico_City").strftime('%a, %d/%m/%y, %H:%M')
  end

  def formatted_expire_time(expire_time)
    expire_time.to_datetime.in_time_zone("America/Mexico_City").strftime("%H:%M on %d/%m/%Y")
  end

  def user_ticket_params
    params.require(:user_ticket).permit(:scanned)
  end





end
