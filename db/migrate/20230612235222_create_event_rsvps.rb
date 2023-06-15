class CreateEventRsvps < ActiveRecord::Migration[7.0]
  def change
    create_table :event_rsvps do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :status
      t.timestamps
    end
  end
end
