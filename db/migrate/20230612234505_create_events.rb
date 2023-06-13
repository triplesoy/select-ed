class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.string :address
      t.string :description
      t.float :price
      t.integer :capacity
      t.references :user, null: false, foreign_key: true
      t.references :community, null: false, foreign_key: true
      t.timestamps
    end
  end
end
