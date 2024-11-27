module Credable
  extend ActiveSupport::Concern

  included do
    has_one :cred, as: :credable, touch: true
  end
end