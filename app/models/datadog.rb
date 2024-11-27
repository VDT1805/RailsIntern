class Datadog < ApplicationRecord
  include Credable
  
  encrypts :api_key, :application_key

  validates :api_key, presence: true
  validates :application_key, presence: true
  validates :subdomain, presence: true

  validates_with DatadogValidator

  after_save_commit do
    BatchDatadogSyncJob.perform_later(id: self.id)
  end
end
