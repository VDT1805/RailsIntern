class Cred < ApplicationRecord
  belongs_to :connection
  has_many :datadogs
  has_many :sendgrids
end
