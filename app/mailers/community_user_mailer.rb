class CommunityUserMailer < ApplicationMailer
  def accepted_community
    # The instance variables are set from the params that were passed in
    @community_user = params[:community_user]
    @user = params[:user]
    @community = params[:community]
    @community_url = community_url(@community)


    # Send the mail to the user's email address
    mail(to: @user.email, bcc: "guillaume@nubanuba.com", subject: "You've been accepted into the #{@community.title}'s community!")
  end
end
