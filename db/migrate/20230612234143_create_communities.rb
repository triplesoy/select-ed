class CreateCommunities < ActiveRecord::Migration[7.0]
  def change
    create_table :communities do |t|
      t.string :title
      t.text :description
      t.string :country
      t.string :city
      t.boolean :is_public
      t.boolean :is_visible

      t.timestamps
    end
  end
end
