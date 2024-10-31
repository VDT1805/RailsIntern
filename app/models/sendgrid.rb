class Sendgrid < ApplicationRecord
  belongs_to :cred

  validates :api_key, presence: true
  validates :subuser, presence: true
end
