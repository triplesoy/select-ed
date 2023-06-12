class CreateEventRsvps < ActiveRecord::Migration[7.0]
  def change
    create_table :event_rsvps do |t|
      t.integer :event_id
      t.integer :user_id
      t.references :users, null: false, foreign_key: true
      t.references :events, null: false, foreign_key: true

      t.timestamps
    end
  end
end
