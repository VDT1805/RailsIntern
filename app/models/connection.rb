class Connection < ApplicationRecord
  belongs_to :app
  belongs_to :org
  has_one :cred
  has_many :accounts

  accepts_nested_attributes_for :cred

  def build_credable(params = {})
    self.cred = Cred.new(label: params.dig(:cred_attributes, :label), credable: app.name.constantize.new(params.dig(:cred_attributes, :credable_attributes)))
  end
end
