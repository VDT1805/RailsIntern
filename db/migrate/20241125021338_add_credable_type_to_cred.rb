class AddCredableTypeToCred < ActiveRecord::Migration[7.2]
  def change
    add_column :creds, :credable_type, :string
  end
end
