require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let (:org) { Org.create!(name: "Company A") }
  let (:user) {
    org.users.create!(email_address: "test@example.com", password: "123")
  }
  describe "GET /" do
    it "should get index" do
      get root_url
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /dashboard" do
    it "unathorized access, redirect to login page" do
      get dashboard_url
      expect(response).to have_http_status(302)
    end

    it "authorized access" do
      get dashboard_url
      expect(response).to redirect_to new_session_url

      post session_url, params: { email_address: user.email_address, password: user.password }
      expect(response).to redirect_to dashboard_url
      follow_redirect!
      expect(response).to have_http_status(200)
    end
  end
end
