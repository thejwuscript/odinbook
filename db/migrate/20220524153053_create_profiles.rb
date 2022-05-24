class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.time :birthday
      t.string :gender
      t.string :location
      t.binary :photo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
