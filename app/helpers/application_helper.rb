module ApplicationHelper
  def user_community_status(community, user)
    if CommunityUser.exists?(user: user, community: community)
      return "You are a member of this community (since #{time_ago_in_words(CommunityUser.find_by(user: user, community: community).created_at)})."
    elsif CommunityUser.exists?(user: user, community: community) && CommunityUser.find_by(user: user, community: community).role == 'moderator'
      return "You are a moderator since #{time_ago_in_words(CommunityUser.find_by(user: user, community: community).created_at)} ago"
    elsif CommunityJoinRequest.exists?(user: user, community: community)
      request = CommunityJoinRequest.find_by(user: user, community: community)
      community.public? ? 'Joined' : "Membership request pending since  #{time_ago_in_words(request.created_at)} ago."
    else
      'Join'
    end
  end



  def ordinal_suffix(day)
    if (11..13).include?(day % 100)
      'th'
    else
      case day % 10
      when 1 then 'st'
      when 2 then 'nd'
      when 3 then 'rd'
      else 'th'
      end
    end
  end




end
