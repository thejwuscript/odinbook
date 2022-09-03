class RemoveFirstNameAndLastNameFromProfiles < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :first_name, :string
    remove_column :profiles, :last_name, :string
  end
end
