class AddImageUrlAndImageDataUrlToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :image_url, :string
    add_column :posts, :image_data_url, :string
  end
end
