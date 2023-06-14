class CommunityJoinRequestPolicy < ApplicationPolicy
  def create?
    user.present? # only allow logged in users to create join requests
  end

  def update?
    user.community_users.find_by(community: record.community)&.admin? # only allow community admins to update join requests

  end

  def destroy?
    update? # same permissions as for updating
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all # if the user is an admin, they can see all join requests
      else
        scope.where(user: user) # otherwise, a user can only see their own join requests
      end
    end
  end
end
