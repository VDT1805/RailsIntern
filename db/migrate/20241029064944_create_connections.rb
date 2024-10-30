class CreateConnections < ActiveRecord::Migration[7.2]
  def change
    create_table :connections do |t|
      t.references :app, null: false, foreign_key: true
      t.references :org, null: false, foreign_key: true

      t.timestamps
    end
  end
end
