require 'rails_helper'

RSpec.describe Datadog, type: :model do
  let(:app) { App.create!(name: 'Datadog Test') }
  let(:org) { Org.create!(name: 'Test Org') }
  let(:connection) {Connection.create!(app: app, org: org)}
  let(:cred) {Cred.create!(connection: connection)}
  describe "Validations", :vcr do 

    it 'Valid Datadog credential' do
      datadog = Datadog.new(
        cred: cred, 
        api_key: Rails.application.credentials.dig(:datadog, :api_key),
        application_key: Rails.application.credentials.dig(:datadog, :application_key),
        subdomain: "datadoghq.com"
      )
      expect(datadog).to be_valid
    end

    it 'Invalid Datadog credential' do
      datadog = Datadog.new(
        cred: cred, 
        api_key: "invalid",
        application_key: "invalid",
        subdomain: "datadoghq.com"
      )
      expect(datadog).not_to be_valid
      expect(datadog.errors[:base]).to include("Invalid credentials, please try another one")
    end
    
  end
end
