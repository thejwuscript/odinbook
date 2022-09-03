class RemoveBirthdayFromProfiles < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :birthday, :time
  end
end
