class OauthController < ApplicationController
  def oauth_callback
      # Exchange auth_code for refresh token and access token
      auth_code = params[:code]

      conn = Faraday.new(
          url: "https://api.dropbox.com",
        )
      form_data = {
        code: auth_code,
        grant_type: "authorization_code",
        client_id: Rails.application.credentials.dig(:dropbox, :app_key),
        client_secret: Rails.application.credentials.dig(:dropbox, :app_secret),
        redirect_uri: oauth_callback_url
      }
      response = conn.post do |req|
          req.url "/oauth2/token"
          req.headers["Content-Type"] = "application/x-www-form-urlencoded"
          req.body = URI.encode_www_form(form_data)
      end
      if response.status == 200
        refresh_token = JSON.parse(response.body)["refresh_token"]
        app = App.find_by(name: params[:app_name])
        org = Current.user.org
        connection_attributes = {
          app_id: app.id,
          org_id: org.id,
          cred_attributes:
            {
              label: "",
              dropbox_attributes:  {
                refresh_token: refresh_token
              }
            }
        }
        @conn = Connection.create!(connection_attributes)
        redirect_to connection_path(@conn)
      else
        raise StandardError, "Dropbox API request failed with status: #{response.status} and body: #{response.body}"
      end
  end
end
