# test/mailers/previews/new_join_request_mailer_preview.rb
class NewJoinRequestMailerP < ActionMailer::Preview
  def new_join_request_notification
    join_request = CommunityJoinRequest.first
    NewJoinRequestMailer.new_join_request_notification(join_request)
  end
end
