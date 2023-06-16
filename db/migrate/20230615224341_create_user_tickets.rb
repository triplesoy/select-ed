class CreateUserTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tickets do |t|
      t.integer :paid_amount
      t.boolean :scanned?
      t.references :user, null: false, foreign_key: true
      t.references :ticket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
