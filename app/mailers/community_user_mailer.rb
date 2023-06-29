class CommunityUserMailer < ApplicationMailer
  def accepted_community
    @community_user = params[:community_user]
    @user = params[:user]
    @community = params[:community]
    mail(to: @user.email, subject: "You've been accepted into the {} community!")
  end

end
