class CommunityUserMailer < ApplicationMailer
  def accepted_community(community_user)
    @community_user = community_user
    @user = @community_user.user
    @community = @community_user.community
    @community_url = community_url(@community)

    mail(to: @user.email, subject: "You've been accepted into the #{@community.title}'s community!")
  end
end
