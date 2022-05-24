class RemovePhotoFromProfile < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :photo
  end
end
