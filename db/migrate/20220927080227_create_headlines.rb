class CreateHeadlines < ActiveRecord::Migration[7.0]
  def change
    create_table :headlines do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.string :url, null: false
      t.string :url_to_image, null: false
      t.datetime :published_at, null: false
      
      t.timestamps
    end
  end
end
