require 'rails_helper'

RSpec.describe Sentry, type: :model do
  let(:app) { App.create!(name: 'Sentry Test') }
  let(:org) { Org.create!(name: 'Test Org') }
  let(:connection) { Connection.create!(app: app, org: org) }
  let(:cred) { Cred.create!(connection: connection) }

  describe "Validations", :vcr do
    it 'Valid Sentry credential' do
      sentry = Sentry.new(
        cred: cred,
        api_token: Rails.application.credentials.dig(:sentry, :api_token),
        organization_id: Rails.application.credentials.dig(:sentry, :organization_id)
      )
      expect(sentry).to be_valid
    end

    it 'Invalid Sentry credential' do
      sentry = Sentry.new(
        cred: cred,
        api_token: "invalid",
        organization_id: "invalid"
      )
      expect(sentry).not_to be_valid
      expect(sentry.errors[:base]).to include("Invalid credentials, please try another one")
    end
  end
end
