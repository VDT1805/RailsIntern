require 'rails_helper'

RSpec.describe DropboxSyncJob, type: :job do
  let(:app) { App.create!(name: 'Dropbox Test') }
  let(:org) { Org.create!(name: 'Test Org') }
  let(:connection) { Connection.create!(app: app, org: org) }

  let(:dropbox_credential) {  }
  let(:limit) { 20 }
  let(:include_removed) { true }

  describe "Dropbox Sync Job Behavior", :vcr do
    subject { described_class.perform_now(cred.dropbox_id, limit, include_removed) }

    context 'when success' do
      let(:cred) { Cred.create!(connection: connection, credable: Dropbox.new(
        refresh_token: Rails.application.credentials.dig(:dropbox, :refresh_token))) }

      it 'Dropbox accounts sync successful' do
        expect { subject }.to change { Account.count }
      end
    end

    context 'when fail' do
      let(:cred) { Cred.create!(connection: connection, credable: Dropbox.new(
        refresh_token: "random")) }

      it 'Dropbox accounts sync unsuccessful' do
        expect { subject }.to raise_error(StandardError, /Dropbox API request failed with status:/)
        expect(Account.count).to eq(0)
      end
    end
  end
end
