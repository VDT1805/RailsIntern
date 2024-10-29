require "rails_helper"

RSpec.describe AppsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/apps").to route_to("apps#index")
    end
  end
end
