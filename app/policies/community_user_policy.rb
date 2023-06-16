class CommunityUserPolicy < ApplicationPolicy
  def destroy?
    record.community.user == user || record.user == user || record.community.moderator.include?(user)
  end

  def make_moderator?
    record.community.user == user || record.community.moderator.include?(user)
  end

  def remove_moderator?
    record.community.user == user || record.community.moderator.include?(user)
  end
end
