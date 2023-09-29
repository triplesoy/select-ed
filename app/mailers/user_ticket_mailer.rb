class UserTicketMailer < ApplicationMailer
  def send_ticket
    @user = params[:user] # Initialize @user. This will be nil if params[:user] is not present.

    @user_ticket = params[:user_ticket]
    @stripe_session_id = params[:stripe_session_id]
    @community = @user_ticket.ticket.event.community
    @event = @user_ticket.ticket.event
    @ticket = @user_ticket.ticket


    @qr_full_name = params[:qr_full_name] # Accessing qr_full_name parameter

    @qr_email = params[:qr_email] # Accessing qr_email parameter
    recipient_email = @user&.email ||   @qr_email

    if @ticket.model == 'regular' && @stripe_session_id.present?
      begin
        @stripe_session = Stripe::Checkout::Session.retrieve(@stripe_session_id)
      rescue Stripe::StripeError => e
        # Handle Stripe errors (e.g., log them)
        @stripe_session = nil
      end
    else
      @stripe_session = nil
    end

    mail(to: recipient_email, bcc: "guillaume@nubanuba.com", subject: "Here's your ticket for the #{@community.title} #{@event.title}'s event!")
  end
end
