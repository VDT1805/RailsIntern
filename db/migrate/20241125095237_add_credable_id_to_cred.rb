class AddCredableIdToCred < ActiveRecord::Migration[7.2]
  def change
    add_column :creds, :credable_id, :integer
  end
end
