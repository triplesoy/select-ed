class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.string :model
      t.integer :price
      t.integer :quantity, default: 0
      t.string :r_code
      t.datetime :expire_time
      t.references :event, null: false, foreign_key: true
      t.timestamps
    end
  end
end
