class CreateAdmins < ActiveRecord::Migration[7.2]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email
      t.string :password
      t.references :org, null: false, foreign_key: true

      t.timestamps
    end
  end
end
