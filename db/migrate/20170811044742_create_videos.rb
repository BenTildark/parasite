class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :title, index: true
      t.string :category, index: true
      t.string :link
      t.string :img
      t.string :site

      t.timestamps
    end
  end
end
