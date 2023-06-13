class AddCategoryToCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :communities, :category, :string
  end
end
