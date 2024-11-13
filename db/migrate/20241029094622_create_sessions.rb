# db/migrate/xxxxxxx_create_sessions.rb

class CreateSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token, null: false
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
    add_index :sessions, :token, unique: true
  end
end