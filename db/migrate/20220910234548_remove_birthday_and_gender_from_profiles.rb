class RemoveBirthdayAndGenderFromProfiles < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :gender, :string
    remove_column :profiles, :birthday, :date
  end
end
