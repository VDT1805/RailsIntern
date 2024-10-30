class Connection < ApplicationRecord
  belongs_to :app
  belongs_to :org
  has_many :creds
  has_many :accounts

  accepts_nested_attributes_for :creds
end
