class UserTicketsController < ApplicationController
  before_action :set_ticket, only: [:edit, :update, :show, :new, :create]
  before_action :set_user_ticket, only: [:edit, :update, :show, :destroy]

  def index
  end

  def show
  end

  def new
    @user_ticket = UserTicket.new(ticket: @ticket)
    authorize @user_ticket
  end

  def create
    raise

    @user_ticket = UserTicket.new(ticket: @ticket)
    @user_ticket.user = current_user
    if @user_ticket.save
      redirect_to "/events/show", alert: "You have successfully purchased a ticket!"
    else
      redirect_to "/events/show", alert: "Failed to buy the ticket."
    end

    authorize @user_ticket
  end

  def edit
  end

  def update
  end

  def destroy
    @user_ticket.destroy
    redirect_to community_path(@community), status: :see_other
    authorize @user_ticket
  end

  private

  def user_ticket_params
    params.require(:event).permit(:user_id, :event_id)
  end

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def set_user_ticket
    @event = UserTicket.find(params[:id])
  end

end
