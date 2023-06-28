class UserTicketMailer < ApplicationMailer
  def send_ticket
    @user_ticket = params[:user_ticket]
    @user = params[:user]
    mail(to: @user.email, subject: "Here's your ticket!")

  end

end
