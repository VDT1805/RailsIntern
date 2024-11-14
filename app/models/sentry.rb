class Sentry < ApplicationRecord
  encrypts :api_token
  validates :organization_id, presence: true
  validates :api_token, presence: true
  belongs_to :cred
end
