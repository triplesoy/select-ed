class UserTicketMailer < ApplicationMailer
  def send_ticket
    @user_ticket = params[:user_ticket]
    @user = params[:user]
    @community = @user_ticket.ticket.event.community
    @event = @user_ticket.ticket.event
    
    mail(to: @user.email, subject: "Here's your ticket for the #{@community.title} #{@event.title}'s event!")
  end

end
