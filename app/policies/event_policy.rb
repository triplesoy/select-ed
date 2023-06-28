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
    record.community.user == user || record.community.community_users.where(user: user, role: "moderator").exists? || user.admin || record.community.community_users.where(user: user, role: "member").exists?
  end

  def new?
    record.community.user == user || record.community.community_users.where(user: user, role: "moderator").exists? || user.admin
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  def update?
    new?
  end

  def destroy?
    new?
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

  def destroy_photo?
    record.community.user == user || record.community.community_users.where(user: user, role: "moderator").exists? || user.admin
  end

end
