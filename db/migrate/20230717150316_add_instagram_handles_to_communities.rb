class AddInstagramHandlesToCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :communities, :instagram_handle_members, :string
    add_column :communities, :instagram_handle_main, :string
  end
end
