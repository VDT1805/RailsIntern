class CreateDatadogs < ActiveRecord::Migration[7.2]
  def change
    create_table :datadogs do |t|
      t.string :application_key
      t.string :subdomain
      t.string :api_key
      t.references :cred, null: false, foreign_key: true

      t.timestamps
    end
  end
end
