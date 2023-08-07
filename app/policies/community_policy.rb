class CommunityPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
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
    true
  end

  def create?
    true
  end

  def edit?
    record.owner == user || user.admin
  end


  def update?
    record.owner == user || record.community_users.where(user: user, role: "moderator").exists? || user.admin
  end

  def destroy?
    record.owner == user || record.community_users.where(user: user, role: "moderator").exists? || user.admin
  end

  def dashboard?
    record.owner == user || record.community_users.where(user: user, role: "moderator").exists? || user.admin
  end

  def my_communities?
    true
  end

  def communities_owned?
    true
  end

  def destroy_community_photo?
    record.owner == user || record.community_users.where(user: user, role: "moderator").exists? || user.admin
  end
end
