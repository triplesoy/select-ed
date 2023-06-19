class UserTicketsController < ApplicationController
  before_action :set_ticket, only: [:edit, :update, :show, :new, :create]
  before_action :set_user_ticket, only: [:edit, :update, :show, :destroy, :confirmation, :validation]

  def index
  end

  def show
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
          size: 120
        )
        ##Using MiniMagick to resize the QR code and place it on the venue image

        qr_image = MiniMagick::Image.read(png.to_s)
        #here i pass the main image of the venue on the QR code
        background = MiniMagick::Image.open(@event.photos.first)

        # resize the QR code to be 90% of the background image's smallest dimension
        smaller_dimension = [background.width, background.height].min
        qr_size = (smaller_dimension * 0.9).round

        # resize the QR code
        qr_image.resize "#{qr_size}x#{qr_size}"

        # calculate the position where the QR code should be placed in order to be centered
        qr_position_x = ((background.width - qr_image.width) / 2).round
        qr_position_y = ((background.height - qr_image.height) / 2).round

        result = background.composite(qr_image) do |c|
          c.compose "Over"    # OverCompositeOp
          c.geometry "+#{qr_position_x}+#{qr_position_y}" # position of QR code on the background image
        end

        # Draw user's name at the top
        result.combine_options do |c|
          c.gravity 'North'
          c.pointsize '40'
          c.draw "text 0,60 '#{current_user.first_name} #{current_user.last_name}'"
          c.fill 'black'
        end

        # Draw dates at the bottom
        result.combine_options do |c|
          c.gravity 'South'
          c.pointsize '40'
          c.draw "text 0,40 'From: #{@event.start_time} to #{@event.end_time}'"
          c.fill 'black'
        end

        result.write("composite_image.png") # replace with actual path where you want to store it
        @user_ticket.qrcode.attach(io: File.open("composite_image.png"), filename: "qr_code.png", content_type: "image/png")

      @user_ticket.save!

      redirect_to ticket_user_ticket_path(ticket_id: @ticket.id, id: @user_ticket.id), alert: "You have successfully purchased a ticket!"

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

  private

  def set_user_ticket
    @user_ticket = UserTicket.find(params[:id])
  end

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

end
