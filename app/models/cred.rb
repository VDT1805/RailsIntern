class Cred < ApplicationRecord
  belongs_to :connection
  has_one :datadog
  has_one :sentry

  accepts_nested_attributes_for :datadog, :sentry
end
