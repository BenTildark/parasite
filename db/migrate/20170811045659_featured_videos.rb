class FeaturedVideos < ActiveRecord::Migration[5.0]
  def change
  	create_table :featured_videos do |t|
      t.string :title
    end
  end
end
