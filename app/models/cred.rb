class Cred < ApplicationRecord
  belongs_to :connection
  has_one :datadog
  has_one :sendgrid

  accepts_nested_attributes_for :datadog, :sendgrid
end
