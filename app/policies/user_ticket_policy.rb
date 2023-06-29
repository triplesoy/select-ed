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

  def edit?
    true
  end

  def update?
    edit?
  end

  def destroy?
    true
  end

  def confirmation?
    record.user == user || record.community.community_users.where(user: user, role: "moderator").exists? || user.admin
  end

  def validation?

    record.ticket.event.community.user == user || record.ticket.event.community.community_users.where(user: user, role: "moderator").exists? || user.admin



  end

  def my_user_tickets?
    true
  end

  def new_scan?
    true
  end

end
