class AddStripePriceIdToTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :stripe_price_id, :string
  end
end
