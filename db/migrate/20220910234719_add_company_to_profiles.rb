class AddCompanyToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :company, :string
  end
end
