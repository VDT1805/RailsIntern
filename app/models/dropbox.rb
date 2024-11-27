class Dropbox < ApplicationRecord
  belongs_to :cred

  encrypts :refresh_token

  validates :refresh_token, presence: true

  after_save_commit do
    DropboxSyncJob.perform_later(self.id, 30, true)
  end
end
