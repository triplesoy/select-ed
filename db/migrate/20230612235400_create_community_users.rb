class CreateCommunityUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :community_users do |t|
      t.string :role
      t.boolean :status
      t.references :user, null: false, foreign_key: true
      t.references :community, null: false, foreign_key: true

      t.timestamps
    end
  end
end
