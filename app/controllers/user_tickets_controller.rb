class UserTicketsController < ApplicationController
  before_action :set_user_ticket, only: [:edit, :update, :show, :destroy, :confirmation, :validation]
  before_action :set_ticket, only: [:edit, :update, :show, :destroy, :confirmation, :validation]

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
    @event = @ticket.event
    @community = @event.community

    if @user_ticket.save!
      @ticket.update(quantity: @ticket.quantity - 1)

      link = validation_page_url(ticket_id: @ticket.id, id: @user_ticket.id)

      qrcode = RQRCode::QRCode.new(link)
      png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: "black",
        file: nil,
        fill: "white",
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 600
      )

      qr_image = MiniMagick::Image.read(png.to_s)
      background = MiniMagick::Image.open(@event.photos.first)

      # Resize the background image to a specific size
      bg_width = 1200
      bg_height = 1800
      background.resize "#{bg_width}x#{bg_height}^"
      background.gravity "center"
      background.extent "#{bg_width}x#{bg_height}"

      # Resize the QR code to a specific size
      qr_code_size = 600
      qr_image.resize "#{qr_code_size}x#{qr_code_size}"

      # Calculate the position where the QR code should be placed to be centered
      qr_position_x = ((background.width - qr_image.width) / 2).round
      qr_position_y = ((background.height - qr_image.height) / 2).round

      result = background.composite(qr_image) do |c|
        c.compose "Over"
        c.geometry "+#{qr_position_x}+#{qr_position_y}"
      end

      result.combine_options do |c|
        c.gravity 'North'
        c.pointsize '90'
        c.font Rails.root.join('app', 'assets', 'fonts', 'fonts', 'GlacialIndifference-Regular.otf').to_s
        c.fill 'black'
        c.draw "text 2,82 '#{@community.title.upcase}'"
      end

      result.combine_options do |c|
        c.gravity 'North'
        c.pointsize '90'
        c.font Rails.root.join('app', 'assets', 'fonts', 'GlacialIndifference-Regular.otf').to_s
        c.fill 'white'
        c.draw "text 1,80 '#{@community.title.upcase}'"
      end

      result.combine_options do |c|
        c.gravity 'North'
        c.pointsize '90'
        c.font Rails.root.join('app', 'assets', 'fonts', 'GlacialIndifference-Regular.otf').to_s
        c.draw "text 1,220 '#{@event.title.upcase}'"
        c.fill 'white'
      end

      result.combine_options do |c|
        c.gravity 'North'
        c.pointsize '70'
        c.font Rails.root.join('app', 'assets', 'fonts', 'GlacialIndifference-Regular.otf').to_s
        c.draw "text 1,420 '#{formatted_start_time}'"
        c.fill 'white'
      end

      result.combine_options do |c|
        c.gravity 'South'
        c.pointsize '70'
        c.font Rails.root.join('app', 'assets', 'fonts', 'GlacialIndifference-Regular.otf').to_s
        c.draw "text 1,220 '#{current_user.full_name.upcase}'"
        c.fill 'white'
      end

      if @user_ticket.ticket.model == "free" && @user_ticket.ticket.expire_time.present?
        valid_until = formatted_expire_time(@user_ticket.ticket.expire_time)

        result.combine_options do |c|
          c.gravity 'South'
          c.pointsize '50'
          c.font Rails.root.join('app', 'assets', 'fonts', 'GlacialIndifference-Regular.otf').to_s
          c.draw "text 2,82 'VALID UNTIL: #{valid_until}'"
          c.fill 'white'
        end
      end

      if @user_ticket.ticket.model == "vip"
        result.combine_options do |c|
          c.gravity 'South'
          c.pointsize '70'
          c.font Rails.root.join('app', 'assets', 'fonts', 'GlacialIndifference-Regular.otf').to_s
          c.draw "text 2,82 'VIP TICKET'"
          c.fill 'white'
        end
      end

      composite_image_path = Rails.root.join('tmp', 'composite_image.png').to_s
      result.write(composite_image_path)
      limit_image_size(composite_image_path, 650) # Limit image size to 650 KB

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
    @user_ticket = UserTicket.find(params[:id])
  end

  def set_ticket
    @ticket = @user_ticket.ticket
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
