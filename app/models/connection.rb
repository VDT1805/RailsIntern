class Connection < ApplicationRecord
  belongs_to :app
  belongs_to :org
  has_one :cred
  has_many :accounts

  accepts_nested_attributes_for :cred
end
