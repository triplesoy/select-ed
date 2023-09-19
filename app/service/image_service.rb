class ImageService
  def initialize(png, event, community, user, user_ticket)
    @png = png
    @event = event
    @community = community
    @user = user
    @user_ticket = user_ticket
  end

  def escape_special_characters(text)
    text.gsub(/['"\\$&]/) { |char| '\\' + char }
  end

  def composite_image
    qr_image = MiniMagick::Image.read(@png.to_s)
    background = MiniMagick::Image.open(@event.photos.first)

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

   # display date only
    draw_text(result, 'North', 70, 'white', 1, 320, formatted_start_date)
    #display start to end time only
    draw_text(result, 'North', 70, 'white', 1, 420, formated_start_to_end_time)

    draw_text(result, 'South', 70, 'white', 1, 220, @user.full_name.upcase)

    if @user_ticket.ticket.model == "free" && @user_ticket.ticket.expire_time.present?
      valid_until = formatted_expire_time(@user_ticket.ticket.expire_time)
      draw_text(result, 'South', 50, 'white', 2, 82, "Guest-list entry - valid before #{valid_until}")
    end

    if @user_ticket.ticket.model == "vip"
      draw_text(result, 'South', 70, 'white', 2, 82, 'VIP TICKET')
    end

    if @user_ticket.ticket.model == "regular"
      draw_text(result, 'South', 70, 'white', 2, 82, 'PAID - General Admission')
    end

    composite_image_path = Rails.root.join('tmp', 'composite_image.png').to_s
    result.write(composite_image_path)

    limit_image_size(composite_image_path, 650) # Limit image size to 650 KB
    return composite_image_path
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



  def formatted_expire_time(expire_time)
    expire_time.in_time_zone("America/Mexico_City").strftime('%I:%M %p')
  end


  def formatted_start_date
    @event.start_time.in_time_zone("America/Mexico_City").strftime('%d/%m/%y')
  end


  def formated_start_to_end_time
    @event.start_time.in_time_zone("America/Mexico_City").strftime('%I:%M %p') + " - " + @event.end_time.in_time_zone("America/Mexico_City").strftime('%I:%M %p')
  end





end
