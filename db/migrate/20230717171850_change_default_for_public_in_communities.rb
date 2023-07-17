class ChangeDefaultForPublicInCommunities < ActiveRecord::Migration[7.0]
  def change
    change_column_default :communities, :public, from: false, to: nil
  end
end
