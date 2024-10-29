class CreateSendgrids < ActiveRecord::Migration[7.2]
  def change
    create_table :sendgrids do |t|
      t.string :subuser
      t.string :api_key
      t.references :cred, null: false, foreign_key: true

      t.timestamps
    end
  end
end
