class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.integer :start_date
      t.integer :end_date
      t.string :address
      t.string :description
      t.float :price
      t.integer :capacity
      t.integer :id_users
      t.integer :id_communities

      t.timestamps
    end
  end
end
