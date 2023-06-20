class UserTicketMailer < ApplicationMailer

  def send_ticket
    @user_ticket = params[:user_ticket]
    @user = params[:user]
    mail(to: "salochara@gmail.com", subject: "Here's your ticket!")
  end

end
