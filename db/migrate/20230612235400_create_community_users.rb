class CreateCommunityUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :community_users do |t|
      t.string :role
      t.boolean :status
      t.integer :id_users
      t.integer :id_communities

      t.timestamps
    end
  end
end
