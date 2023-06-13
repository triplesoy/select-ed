class CreateCommunityJoinRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :community_join_requests do |t|
      t.string :status
      t.references :users, null: false, foreign_key: true
      t.references :communities, null: false, foreign_key: true

      t.timestamps
    end
  end
end
