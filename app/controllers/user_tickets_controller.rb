class UserTicketsController < ApplicationController
  before_action :set_ticket, only: [:edit, :update, :show, :new, :create]
  before_action :set_user_ticket, only: [:edit, :update, :show, :destroy, :confirmation, :validation]

  def index
  end

  def show
    @event = @ticket.event
    authorize @user_ticket
  end

  def new
    @user_ticket = UserTicket.new(ticket: @ticket)
    authorize @user_ticket
  end

  def create
    @user_ticket = UserTicket.new(ticket: @ticket)
    @user_ticket.user = current_user
    @ticket.update(quantity: @ticket.quantity - 1)
    @event = @ticket.event
    @community = @event.community

    if @user_ticket.save!
    ##QR CODE
        link = validation_page_url(ticket_id: @ticket.id, id: @user_ticket.user.id)
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
          size: 480
        )
        ##Using MiniMagick to resize the QR code and place it on the venue image

      qr_image = MiniMagick::Image.read(png.to_s)
      background = MiniMagick::Image.open(@event.photos.first)

      # Resize the background image to a specific size
      bg_width = 1200
      bg_height = 1200
      background.resize "#{bg_width}x#{bg_height}^"
      background.gravity "center"
      background.extent "#{bg_width}x#{bg_height}"

      # Resize the QR code to a specific size
      qr_code_size = 480
      qr_image.resize "#{qr_code_size}x#{qr_code_size}"

      # Calculate the position where the QR code should be placed to be centered
      qr_position_x = ((background.width - qr_image.width) / 2).round
      qr_position_y = ((background.height - qr_image.height) / 2).round

      result = background.composite(qr_image) do |c|
        c.compose "Over"
        c.geometry "+#{qr_position_x}+#{qr_position_y}"
      end

      # Draw community's name at the top
      result.combine_options do |c|
        c.gravity 'North'
        c.pointsize '80'
        c.font Rails.root.join('app', 'assets', 'fonts', 'GasoekOne-Regular.ttf').to_s
        c.draw "text 1,80 '#{@community.title}'"
        c.fill 'white'
      end


      result.combine_options do |c|
        c.gravity 'North'
        c.pointsize '60'
        c.font Rails.root.join('app', 'assets', 'fonts', 'GasoekOne-Regular.ttf').to_s
        c.draw "text 1,160 '#{@event.title}'"
        c.fill 'white'
      end

      # Draw dates at the bottom
      result.combine_options do |c|
        c.gravity 'South'
        c.pointsize '70'
        c.font Rails.root.join('app', 'assets', 'fonts', 'GasoekOne-Regular.ttf').to_s
        c.draw "text 1,90 '#{current_user.full_name}'"
        c.fill 'white'
      end

      result.write("composite_image.png")
      @user_ticket.qrcode.attach(io: File.open("composite_image.png"), filename: "qr_code.png", content_type: "image/png")

      @user_ticket.save!

      redirect_to confirmation_page_path(@user_ticket), alert: "You have successfully purchased a ticket!"

    else
      render :new, status: :unprocessable_entity, alert: "Failed to buy the tickets."
    end

    authorize @user_ticket
  end

  def edit
  end

  def update
  end

  def destroy
    @user_ticket.destroy
    redirect_to community_path(@ticket.event.community), status: :see_other
    authorize @user_ticket
  end

  def confirmation
   @ticket = @user_ticket.ticket
   @event = @ticket.event
    @user_ticket
    authorize @user_ticket
  end

  def validation
    authorize @user_ticket
  end

  def my_user_tickets
    @user = current_user
    @my_user_tickets = @user.user_tickets
    authorize @my_user_tickets
  end

  private

  def set_user_ticket
    @user_ticket = UserTicket.find(params[:id])
  end

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

end
