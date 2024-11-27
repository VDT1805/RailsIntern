class App < ApplicationRecord
    has_many :connections
    has_many :orgs, through: :connections
end
