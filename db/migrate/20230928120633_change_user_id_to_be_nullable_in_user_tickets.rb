class ChangeUserIdToBeNullableInUserTickets < ActiveRecord::Migration[7.0]
  def change
    change_column_null :user_tickets, :user_id, true
  end
end
