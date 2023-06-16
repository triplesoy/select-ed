class CommunityUserPolicy < ApplicationPolicy
  def destroy?
    record.community.user == user || record.user == user || record.community.moderator.include?(user)
  end
end
