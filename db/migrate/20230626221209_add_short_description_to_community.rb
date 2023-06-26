class AddShortDescriptionToCommunity < ActiveRecord::Migration[7.0]
  def change
    add_column :communities, :short_description, :text
  end
end
