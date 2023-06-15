class CommunityJoinRequestPolicy < ApplicationPolicy
  def create?
    # Any logged-in user can create a join request
    user.present?
  end

  def update?
    # Only admins of the community or the user who created the join request can update it
    record.community.user == user
  end

  def destroy?
    # Only admins of the community or the user who created the join request can destroy it
    record.community.admin == user || record.user == user
  end
end
