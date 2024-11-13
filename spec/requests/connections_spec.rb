require 'rails_helper'

include Rails.application.routes.url_helpers

RSpec.describe "Connections", type: :request do
  let(:org) { Org.create!(name: "Company A") }
  let(:application) { App.create!(name: "Datadog") }
  let (:user) {
    org.users.create!(email_address: "test1@example.com", password: "123")
  }
  let(:valid_attributes) do
    {
      app_id: application.id,
      org_id: org.id,
      cred_attributes: {
        label: "Sample Label",
        datadog_attributes: {
          api_key: Rails.application.credentials.dig(:datadog, :api_key),
          application_key: Rails.application.credentials.dig(:datadog, :application_key),
          subdomain: "datadoghq.com"
        }
      }
    }
  end

  let(:invalid_attributes) do
    {
      app_id: application.id,
      org_id: org.id,
      cred_attributes: {
        label: "Sample Label",
        datadog_attributes: {
          api_key: "invalid",
          application_key: "invalid",
          subdomain: "datadoghq.com"
        }
      }
    }
  end

  before(:each) {
    post session_url, params: { email_address: user.email_address, password: user.password }
  }


  describe "GET /index" do
    it "returns a successful response" do
      get connections_path
      expect(response).to be_successful
    end
  end


  describe "GET /new" do
    it "returns a successful response" do
      get new_app_connection_url(app_id: application.id)
      expect(response).to be_successful
      expect(response.body).to include("Datadog")
    end
  end

  describe "GET /show", :vcr do
    it "returns a successful response" do
      conn = Connection.create!(valid_attributes)
      get connection_url(id: conn.id)
      expect(response).to be_successful
      expect(response.body).to include(conn.id.to_s)
    end
  end

  describe "POST /create", :vcr do
    context "with valid parameters" do
      it "creates a new Connection" do
        expect {
          post app_connections_path(app_id: application.id), params: { connection: valid_attributes }
        }.to change(Connection, :count).by(1)
      end

      it "redirects to the connection show page" do
        post app_connections_path(app_id: application.id), params: { connection: valid_attributes }
        connection = Connection.last
        expect(response).to redirect_to(connection_url(id: connection.id.to_s))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Connection" do
        expect {
          post app_connections_path(app_id: application.id), params: { connection: invalid_attributes }
        }.to change(Connection, :count).by(0)
      end

      it "renders the :new template with unprocessable entity status" do
        post app_connections_path(app_id: application.id), params: { connection: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
