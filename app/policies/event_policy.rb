class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    record.community.user_id == user.id
  end

  def create?
    new?
  end

  def edit?
    record.user == user || record.community.community_users.where(user: user, role: "moderator").exists? || user.admin
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def my_events?
    record.users.include?(user)
  end


  def events_owned?
    record.user == user
  end

  def event_dashboard?
    record.community.user == user || record.community.community_users.where(user: user, role: "moderator").exists? || user.admin
  end

end
