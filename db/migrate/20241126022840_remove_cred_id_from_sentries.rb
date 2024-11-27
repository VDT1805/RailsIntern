class RemoveCredIdFromSentries < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :sentries, :creds
    remove_column :sentries, :cred_id, :integer
  end
end
