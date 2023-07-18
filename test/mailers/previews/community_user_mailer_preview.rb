class CommunityUserMailerPreview < ActionMailer::Preview
  def accepted_community
    community_user = CommunityUser.first # Replace with the appropriate record or create a test record if needed
    user = community_user.user
    community = community_user.community

    CommunityUserMailer.with(community_user: community_user, user: user, community: community).accepted_community
  end
end
