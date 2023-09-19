class UserTicketMailer < ApplicationMailer
  def send_ticket
    @user_ticket = params[:user_ticket]
    @user = params[:user]
    @stripe_session_id = params[:stripe_session_id]  # Pass this in when you call the mailer
    @community = @user_ticket.ticket.event.community
    @event = @user_ticket.ticket.event
    @ticket = @user_ticket.ticket

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

    mail(to: @user.email, bcc: "guillaume@nubanuba.com", subject: "Here's your ticket for the #{@community.title} #{@event.title}'s event!")
  end
end
