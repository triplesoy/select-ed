class AddExpireTimeToTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :expire_time, :datetime
  end
end
