class Cred < ApplicationRecord
  belongs_to :connection
  has_one :datadog
  has_one :sentry
  has_one :dropbox

  accepts_nested_attributes_for :datadog, :sentry, :dropbox
end
