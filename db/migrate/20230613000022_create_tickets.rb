class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.string :type
      t.integer :price
      t.integer :user_id
      t.integer :event_id
      t.references :users, null: false, foreign_key: true
      t.references :events, null: false, foreign_key: true

      t.timestamps
    end
  end
end
