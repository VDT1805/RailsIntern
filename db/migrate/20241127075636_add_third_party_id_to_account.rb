class AddThirdPartyIdToAccount < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :third_party_id, :string, null: false
    add_index :accounts, :third_party_id
  end
end
