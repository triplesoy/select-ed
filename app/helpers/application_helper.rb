module ApplicationHelper
  def user_community_status(community, user)
    if CommunityJoinRequest.exists?(user: user, community: community)
      request = CommunityJoinRequest.find_by(user: user, community: community)
      community.is_public? ? 'Joined' : "Membership request sent #{time_ago_in_words(request.created_at)} ago"
    else
      'Join'
    end
  end
end
