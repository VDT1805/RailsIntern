class Connection < ApplicationRecord
  include ActiveModel::Validations
  belongs_to :app
  belongs_to :org
  has_one :cred
  has_many :accounts

  accepts_nested_attributes_for :cred
  validates_with ConnectionValidator
end
