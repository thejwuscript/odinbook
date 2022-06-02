class RemoveImageUrlFromPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :image_url
  end
end
