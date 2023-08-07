class NotificationsController < ApplicationController
  def mark_all_as_read
      current_user.notifications.where(read_at: nil).update_all(read_at: Time.current)
      # Respond to the client
      respond_to do |format|
        format.json { render json: { status: 'success' } }
    end
  end



end
