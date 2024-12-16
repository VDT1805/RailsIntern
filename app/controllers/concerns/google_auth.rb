require 'google/api_client/client_secrets'
module GoogleAuth
  extend ActiveSupport::Concern
  
  class_methods do
    def create_auth_client(scope, redirect_uri, additional_params = {})
      client_secrets_hash = {
        "web" => {
          "client_id" => Rails.application.credentials.dig(:google,:client_id),
          "client_secret" => Rails.application.credentials.dig(:google,:client_secret),
          "auth_uri" => "https://accounts.google.com/o/oauth2/auth",
          "token_uri" => "https://oauth2.googleapis.com/token"
        }
      }
      client_secrets = Google::APIClient::ClientSecrets.new(client_secrets_hash)
      auth_client = client_secrets.to_authorization

      auth_client.update!(
        scope: scope,
        redirect_uri: redirect_uri,
        additional_parameters: additional_params
      )

      auth_client
    end
  end
end