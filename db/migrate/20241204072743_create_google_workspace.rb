class CreateGoogleWorkspace < ActiveRecord::Migration[7.2]
  def change
    create_table :google_workspaces do |t|
      t.string :refresh_token

      t.timestamps
    end
  end
end
