class Cred < ApplicationRecord
  belongs_to :connection
  has_many :datadogs
  has_many :sendgrids

  accepts_nested_attributes_for :datadogs, :sendgrids
end
