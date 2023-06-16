module ApplicationHelper
  def user_community_status(community, user)
    if CommunityUser.exists?(user: user, community: community)
      return "Member since #{time_ago_in_words(CommunityUser.find_by(user: user, community: community).created_at)} ago"
    elsif CommunityUser.exists?(user: user, community: community) && CommunityUser.find_by(user: user, community: community).role == 'moderator'
      return "Moderator since #{time_ago_in_words(CommunityUser.find_by(user: user, community: community).created_at)} ago"
    elsif CommunityJoinRequest.exists?(user: user, community: community)
      request = CommunityJoinRequest.find_by(user: user, community: community)
      community.is_public? ? 'Joined' : "Membership request sent #{time_ago_in_words(request.created_at)} ago"
    else
      'Join'
    end
  end
end
