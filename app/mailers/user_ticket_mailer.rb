class UserTicketMailer < ApplicationMailer
  def send_ticket
    @user_ticket = params[:user_ticket]
    @user = params[:user]
    mail(to: @user.email, subject: "Here's your ticket for the #{@community.title} #{@event.title}'s event!")
  end

end
