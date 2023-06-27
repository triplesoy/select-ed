class UpdateForeignKeyConstraintOnUserTickets < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :user_tickets, :tickets
    add_foreign_key :user_tickets, :tickets, on_delete: :cascade
  end
end
