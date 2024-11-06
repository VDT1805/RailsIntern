require 'rails_helper'

RSpec.describe DatadogSyncJob, type: :job do
  let(:app) { App.create!(name: 'Datadog Test') }
  let(:org) { Org.create!(name: 'Test Org') }
  let(:connection) { Connection.create!(app: app, org: org) }
  let(:cred) { Cred.create!(connection: connection) }
  let(:subdomain) { "datadoghq.com" }
  let(:job) { }

  describe "Datadog Sync Job Behavior", :vcr do
    subject { described_class.perform_now(job) }

    context 'when success' do
      let(:job) do
        {
          api_key: Rails.application.credentials.dig(:datadog, :api_key),
          application_key: Rails.application.credentials.dig(:datadog, :application_key),
          subdomain: subdomain,
          connection_id: connection.id
        }
      end

      it 'Datadog accounts sync successful' do
        expect { subject }.to change { Account.count }.by(10)
      end
    end

    context 'when fail' do
      let(:job) do
        {
          api_key: "",
          application_key: "",
          subdomain: "datadoghq.com",
          connection_id: connection.id
        }
      end

      it 'Datadog accounts sync unsuccessful' do
        expect { subject }.to raise_error(StandardError, /Datadog API request failed with status:/)
        expect(Account.count).to eq(0)
      end
    end
  end
end
