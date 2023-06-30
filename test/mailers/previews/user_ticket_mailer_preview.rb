# Preview all emails at http://localhost:3000/rails/mailers/user_ticket_mailer
class UserTicketMailerPreview < ActionMailer::Preview
  def send_ticket
    @user_ticket = params[:user_ticket]
    @user = params[:user]
    @community = @user_ticket.ticket.event.community
    @event = @user_ticket.ticket.event
    @ticket = @user_ticket.ticket

    mail(to: @user.email, subject: "Here's your ticket for the #{@community.title} #{@event.title}'s event!")
  end

end
