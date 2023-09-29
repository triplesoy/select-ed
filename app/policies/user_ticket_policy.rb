class UserTicketPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    record.user == user || record.ticket.event.community.community_users.where(user: user, role: ["moderator", "admin"]).exists? || user.admin
  end

  def new?
    true
  end

  def create?
    new?
  end

  def check_processed?
new?
  end

  def manual_new?
    true
  end

  def manual_create?
    true
  end


  def payment_success?
    new?
  end

def get_payment_status?
  new?
end

  def stripe_webhook?
    new?
  end

  def create_ticket?
    new?
  end



  def checkout?
    new?
  end

  def success?
new?
  end

  def cancel?
    new?
  end



  def edit?
    true
  end

  def update?
    edit?
  end

  def destroy?
    true
  end

  def cancel?
  new?
  end
def confirmation_manual?
  new?
end 


  def confirmation?
    record.user == user || record.community.community_users.where(user: user, role: "moderator").exists? || user.admin
  end

  def validation?
    record.ticket.event.community.owner == user || record.ticket.event.community.community_users.where(user: user, role: "moderator").exists? || user.admin
  end

  def my_user_tickets?
    true
  end

  def new_scan?
    true
  end

end
