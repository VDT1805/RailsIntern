class CreateSentries < ActiveRecord::Migration[7.2]
  def change
    create_table :sentries do |t|
      t.string :organization_id
      t.string :api_token
      t.references :cred, null: false, foreign_key: true

      t.timestamps
    end
  end
end
