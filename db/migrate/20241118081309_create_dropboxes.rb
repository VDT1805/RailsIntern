class CreateDropboxes < ActiveRecord::Migration[7.2]
  def change
    create_table :dropboxes do |t|
      t.references :cred, null: false, foreign_key: true
      t.string :refresh_token

      t.timestamps
    end
  end
end
