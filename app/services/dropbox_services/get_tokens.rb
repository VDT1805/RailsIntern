module DropboxServices
  class GetTokens
    def initialize
      @conn = Faraday.new(
        url: "https://api.dropbox.com",
      )
    end

    def get_access_token(refresh_token)
      form_data = {
        grant_type: "refresh_token",
        refresh_token: refresh_token,
        client_id: Rails.application.credentials.dig(:dropbox, :app_key),
        client_secret: Rails.application.credentials.dig(:dropbox, :app_secret)
      }
      response = conn.post do |req|
          req.url "/oauth2/token"
          req.headers["Content-Type"] = "application/x-www-form-urlencoded"
          req.body = URI.encode_www_form(form_data)
      end
      if response.status == 200
        return JSON.parse(response.body)["access_token"]
      else
        raise StandardError, "Dropbox API request failed with status: #{response.status} and body: #{response.body}"
      end
    end

    def get_refresh_token(auth_code,oauth_callback_url)
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
          return JSON.parse(response.body)["refresh_token"]
        else
            raise StandardError, "Dropbox API request failed with status: #{response.status} and body: #{response.body}"
        end
      end
    private
      attr_reader :conn
    end
end