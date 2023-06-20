class CommunityUserPolicy < ApplicationPolicy
  def destroy?
    !record.role == 'admin' || !record.user.admin || !record.user == user
  end

  def make_moderator?
    true
  end

  def remove_moderator?
    true
  end
end
