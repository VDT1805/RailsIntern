class Org < ApplicationRecord
    has_many :users
    has_many :employees
    has_many :connections
    has_many :apps, through: :connections

    accepts_nested_attributes_for :users # Allows org to create its child
end
