module ManualQrCodeGenerator


  def escape_special_characters(text)
    text.gsub(/['"\\$&]/) { |char| '\\' + char }
  end

  def generate_and_attach_qr_code(user_ticket_id, stripe_session_id, qr_email, qr_full_name)
    begin
      user_ticket = UserTicket.find_by(id: user_ticket_id)
      # Validate required objects
      raise "User Ticket is nil" unless user_ticket
      raise "Ticket is nil" unless user_ticket.ticket
      raise "Event is nil" unless user_ticket.ticket.event
      raise "Community is nil" unless user_ticket.ticket.event.community

      @ticket = user_ticket.ticket
      @current_user = user_ticket.user
      @event = user_ticket.ticket.event
      @community = @event.community

    # default_url_options[:host] = 'localhost:3000'

    # Generate QR code
    link = validation_page_url(ticket_id: @ticket.id, id: user_ticket.id)
    png = QrCodeService.new(link).generate

    # Create composite image
    qr_image = MiniMagick::Image.read(png.to_s) # replaced @png with png
    background = MiniMagick::Image.open(@event.photos.first) # replaced @event with event


    # Resize and setup background image
    bg_width, bg_height = 1200, 1800
    background.resize "#{bg_width}x#{bg_height}^"
    background.gravity "center"
    background.extent "#{bg_width}x#{bg_height}"

    # Resize the QR code
    qr_code_size = 600
    qr_image.resize "#{qr_code_size}x#{qr_code_size}"

    # Calculate QR code position for centering
    qr_position_x = ((background.width - qr_image.width) / 2).round
    qr_position_y = ((background.height - qr_image.height) / 2).round

      result = background.composite(qr_image) do |c|
        c.compose "Over"
        c.geometry "+#{qr_position_x}+#{qr_position_y}"
      end

    # Apply text overlays
    draw_text(result, 'North', 90, 'black', 2, 82, @community.title.upcase)
    draw_text(result, 'North', 90, 'white', 1, 80, @community.title.upcase)
    draw_text(result, 'North', 90, 'white', 1, 220, @event.title.upcase)
    draw_text(result, 'North', 70, 'white', 1, 420, formatted_start_time)
    draw_text(result, 'South', 70, 'white', 1, 220, escape_special_characters(qr_full_name.upcase))

    if @user_ticket.ticket.model == "free" && @user_ticket.ticket.expire_time.present?
      valid_until = formatted_expire_time(@user_ticket.ticket.expire_time)
      draw_text(result, 'South', 50, 'white', 2, 82, "Valid until: #{valid_until}")
    end

    if @user_ticket.ticket.model == "vip"
      draw_text(result, 'South', 70, 'white', 2, 82, 'VIP TICKET')
    end

    composite_image_path = Rails.root.join('tmp', 'composite_image.png').to_s
    result.write(composite_image_path)

    limit_image_size(composite_image_path, 650) # Limit image size to 650 KB
    return composite_image_path
    # Attach QR code
    user_ticket.qrcode.attach(io: File.open(composite_image_path), filename: "qr_code.png", content_type: "image/png")

        # Mark ticket as processed
        user_ticket.update!(processed: true)

    # Send email
    UserTicketMailer.with(email: qr_email, user_ticket: user_ticket).send_ticket.deliver_now


  rescue => e
    # Log the error
    Rails.logger.error "Error in ManualQrCodeGenerator: #{e.message}"
    Rails.logger.debug "UserTicket ID: #{user_ticket_id.inspect}"
Rails.logger.debug "UserTicket Object: #{user_ticket.inspect}"
  end

  end
end



private

def draw_text(result, gravity, pointsize, color, x, y, text)
  result.combine_options do |c|
    c.gravity gravity
    c.pointsize pointsize.to_s
    c.font "Glacial-Indifference-Regular"
    c.fill color
    c.draw "text #{x},#{y} '#{escape_special_characters(text)}'"
  end
end

def limit_image_size(image_path, kb_limit)
  # This will limit the image size without degrading its quality
  while File.size(image_path) > kb_limit * 1024
    image = MiniMagick::Image.open(image_path)
    image.resize "90%" # Reduce size by 10%
    image.write(image_path)
  end
end

def formatted_start_time
  @event.start_time.in_time_zone("America/Mexico_City").strftime('%a, %d/%m/%y, %H:%M')
end
