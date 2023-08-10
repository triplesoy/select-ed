class NewJoinRequestMailer < ApplicationMailer
  def new_join_request_notification(join_request)
    @join_request = join_request
    @recipient = @join_request.community.owner
    @unread_requests_count = Notification.unread.where(type: 'NewCommunityJoinRequestNotification').count
    @unread_join_requests = Notification.unread.where(type: 'NewCommunityJoinRequestNotification')

    # Determine if the word should be singular or plural
    request_word = @unread_requests_count == 1 ? 'request' : 'requests'

    mail(to: @recipient.email, bcc: "guillaume@nubanuba.com", subject: "You have #{@unread_requests_count} pending join #{request_word}")
  end
end
