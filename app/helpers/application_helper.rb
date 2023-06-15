module ApplicationHelper
  def user_community_status(community, user)
    if CommunityJoinRequest.exists?(user_id: user.id, community_id: community.id)
      request = CommunityJoinRequest.find_by(user_id: user.id, community_id: community.id)
      community.is_public? ? 'Joined' : request.status.capitalize
    else
      'Join'
    end
  end
end
