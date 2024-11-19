class Dropbox < ApplicationRecord
  belongs_to :cred

  encrypts :refresh_token

  validates :refresh_token, presence: true
end
