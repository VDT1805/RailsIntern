class Cred < ApplicationRecord
  delegated_type :credable, types: %w[ Datadog Dropbox Sentry GoogleWorkspace], dependent: :destroy

  belongs_to :connection

  accepts_nested_attributes_for :credable
end
