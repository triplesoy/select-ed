class CommunityUserMailerPreview < ActionMailer::Preview
  def accepted_community
    # Assuming you have some CommunityUser, User, and Community records in your database
    community_user = CommunityUser.first
    user = User.first
    community = Community.first

    # Pass these records to the mailer
    CommunityUserMailer.with(
      community_user: community_user,
      user: user,
      community: community
    ).accepted_community
  end
end
