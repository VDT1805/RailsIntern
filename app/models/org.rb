class Org < ApplicationRecord
    has_many :admins
    has_many :employees
    has_many :connections
    has_many :apps, through: :connections

    accepts_nested_attributes_for :admins # Allows org to create its child
end
