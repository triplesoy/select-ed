class CommunityUserPolicy < ApplicationPolicy
  def destroy?
    !record.role == 'moderator' || !record.user.admin || !record.user == user
  end

  def make_moderator?
    true
  end

  def remove_moderator?
    true
  end

  def user_history?
    user.admin || record.community.user == user || user.community_users.find_by(community: record.community).role == 'moderator'
  end
end
