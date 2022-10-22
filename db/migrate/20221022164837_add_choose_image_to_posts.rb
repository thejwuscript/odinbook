class AddChooseImageToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :choose_image, :string
  end
end
