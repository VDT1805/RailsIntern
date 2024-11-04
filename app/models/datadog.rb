class Datadog < ApplicationRecord
  belongs_to :cred

  encrypts :api_key, :application_key

  validates :api_key, presence: true
  validates :application_key, presence: true
  validates :subdomain, presence: true

end
