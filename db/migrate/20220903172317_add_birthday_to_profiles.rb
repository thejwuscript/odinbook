class AddBirthdayToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :birthday, :date
  end
end
