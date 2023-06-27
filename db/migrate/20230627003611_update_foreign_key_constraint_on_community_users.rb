class UpdateForeignKeyConstraintOnCommunityUsers < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :community_users, :communities
    add_foreign_key :community_users, :communities, on_delete: :cascade
  end
end
