require "rails_helper"

RSpec.describe AppsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/orgs/1/apps").to route_to("apps#index", org_id: '1')
    end
  end
end
