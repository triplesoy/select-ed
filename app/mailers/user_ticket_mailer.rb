class UserTicketMailer < ApplicationMailer
  def send_ticket
    @user_ticket = params[:user_ticket]
    @user = params[:user]
    @community = @user_ticket.ticket.event.community
    @event = @user_ticket.ticket.event
    @ticket = @user_ticket.ticket


    # mail(to: @user.email, bcc: "guillaume@nubanuba.com, maximiliano_at@outlook.com", subject: "Here's your ticket for the #{@community.title} #{@event.title}'s event!")

    mail(to: @user.email, bcc: "guillaume@nubanuba.com", subject: "Here's your ticket for the #{@community.title} #{@event.title}'s event!")
  end

end
