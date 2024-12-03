class RemoveCredIdFromDatadogs < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :datadogs, :creds
    remove_column :datadogs, :cred_id, :integer
  end
end
