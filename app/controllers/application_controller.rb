class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :load_notifications, :set_notifications

  include Pundit::Authorization

  # Pundit: allow-list approach
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?


  def index
    @notifications = current_user.admin? ? Notification.all : Notification.for_user(current_user)
  end

  private


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :birthdate, :address, :country, :instagram_handle, :occupation, :avatar, :gender, :phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :birthdate, :address, :country, :instagram_handle, :occupation, :avatar, :gender, :phone_number])
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to root_path
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def load_notifications
    @notifications = current_user.notifications if user_signed_in?
  end

  def set_notifications
    if user_signed_in?
      if current_user.admin?
        @notifications = Notification.order(created_at: :desc)
      else
        @notifications = current_user.notifications.order(created_at: :desc)
      end
      @unread_notifications_count = @notifications.select do |notification|
        # Check if notification is unread and its associated join request is still present
        notification.read_at.nil? && notification.params[:community_join_request].present?
      end.count
    end
  end



end
