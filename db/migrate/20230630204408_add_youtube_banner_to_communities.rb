class AddYoutubeBannerToCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :communities, :youtube_banner, :string
  end
end
