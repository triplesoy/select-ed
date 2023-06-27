class UpdateForeignKeyConstraintOnTickets < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :tickets, :events
    add_foreign_key :tickets, :events, on_delete: :cascade
  end
end
