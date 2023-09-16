class TicketProcessingWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers  # Include URL Helpers



  def perform(user_ticket_id)
    user_ticket = UserTicket.find(user_ticket_id)
    ticket = user_ticket.ticket
    current_user = user_ticket.user

    # default_url_options[:host] = 'localhost:3000'

    # Generate QR code
    link = validation_page_url(ticket_id: ticket.id, id: user_ticket.id)
    png = QrCodeService.new(link).generate

    # Create composite image
    composite_image_path = ImageService.new(png, ticket.event, ticket.event.community, current_user, user_ticket).composite_image

    # Attach QR code
    user_ticket.qrcode.attach(io: File.open(composite_image_path), filename: "qr_code.png", content_type: "image/png")

    # Send email
    UserTicketMailer.with(user: current_user, user_ticket: user_ticket).send_ticket.deliver_now

    # Mark ticket as processed
    user_ticket.update!(processed: true)
  end


end
