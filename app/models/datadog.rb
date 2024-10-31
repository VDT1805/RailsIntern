class Datadog < ApplicationRecord
  belongs_to :cred

  validates :api_key, presence: true
  validates :application_key, presence: true
  validates :subdomain, presence: true
end
