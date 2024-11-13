class AddOrgRefToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :org, null: false, foreign_key: true
  end
end
