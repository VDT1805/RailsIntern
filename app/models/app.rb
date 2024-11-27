class App < ApplicationRecord
    has_many :connections
    has_many :orgs, through: :connections

    delegate :field_partial_name, to: :proxy_class

    def proxy_class
        "#{name}Proxy".constantize
    end
end
