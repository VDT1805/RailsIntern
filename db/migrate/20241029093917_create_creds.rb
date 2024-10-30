class CreateCreds < ActiveRecord::Migration[7.2]
  def change
    create_table :creds do |t|
      t.string :label
      t.references :connection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
