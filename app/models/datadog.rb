class Datadog < ApplicationRecord
  belongs_to :cred

  encrypts :api_key, :application_key

  validates :api_key, presence: true
  validates :application_key, presence: true
  validates :subdomain, presence: true

  validates_with DatadogValidator

  after_save_commit do
    BatchDatadogSyncJob.perform_later(connection_id: self.cred.connection_id)
  end
end
