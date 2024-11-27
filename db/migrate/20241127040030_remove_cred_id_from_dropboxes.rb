class RemoveCredIdFromDropboxes < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :dropboxes, :creds
    remove_column :dropboxes, :cred_id, :integer
  end
end
