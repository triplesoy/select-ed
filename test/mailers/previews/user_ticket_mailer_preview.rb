class UserTicketMailerPreview < ActionMailer::Preview
  def send_ticket
    user_ticket = UserTicket.last # Replace with the appropriate record or create a test record if needed
    user = user_ticket.user


    UserTicketMailer.with(user_ticket: user_ticket, user: user).send_ticket
  end
end
