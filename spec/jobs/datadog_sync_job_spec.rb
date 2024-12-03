require 'rails_helper'

RSpec.describe DatadogSyncJob, type: :job do
  let(:app) { App.create!(name: 'Datadog Test') }
  let(:org) { Org.create!(name: 'Test Org') }
  let(:connection) { Connection.create!(app: app, org: org) }
  # let(:cred) { Cred.create!(connection: connection) }
  let(:subdomain) { "datadoghq.com" }
  let (:pagesize) { 1 }
  let (:page) { 0 }
  let(:job) { }

  describe "Datadog Sync Job Behavior", :vcr do
    subject { described_class.perform_now(job) }

    context 'when success' do
      let(:cred) { Cred.create!(connection: connection, credable: Datadog.new(
        api_key: Rails.application.credentials.dig(:datadog, :api_key),
        application_key: Rails.application.credentials.dig(:datadog, :application_key),
        subdomain: subdomain)) }
      let(:job) do
        {
          id: cred.datadog_id,
          pagesize: pagesize,
          page: page
        }
      end

      it 'Datadog accounts sync successful' do
        expect { subject }.to change { Account.count }.by(pagesize)
      end
    end

    context 'when fail' do
      let(:cred) do
        cred = Cred.new(connection: connection, credable: Datadog.new(
          api_key: "invalid",
          application_key: "invalid",
          subdomain: subdomain
        ))
        cred.save!(validate: false)
        cred
      end
      let(:job) do
        {
          id: cred.datadog_id,
          pagesize: pagesize,
          page: page
        }
      end

      it 'Datadog accounts sync unsuccessful' do
        expect { subject }.to raise_error(StandardError, /Datadog API request failed with status:/)
        expect(Account.count).to eq(0)
      end
    end
  end
end
