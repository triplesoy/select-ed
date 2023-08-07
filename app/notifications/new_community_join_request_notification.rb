class NewCommunityJoinRequestNotification < Noticed::Base
  deliver_by :database
  param :community_join_request

  def to
    params[:community_join_request].community.owner
  end

  def payload
    {
      community_join_request_id: params[:community_join_request].id
    }
  end
end
