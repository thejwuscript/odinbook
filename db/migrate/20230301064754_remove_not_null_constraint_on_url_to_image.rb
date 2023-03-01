class RemoveNotNullConstraintOnUrlToImage < ActiveRecord::Migration[7.0]
  def change
    change_column_null :headlines, :url_to_image, true
  end
end