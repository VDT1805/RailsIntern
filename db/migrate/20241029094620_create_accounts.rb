class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :email
      t.string :status
      t.references :connection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
