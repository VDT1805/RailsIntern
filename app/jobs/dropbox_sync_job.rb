class DropboxSyncJob < ApplicationJob
  queue_as :default

  def perform(id, limit, include_removed = false)
    dropbox_credential = Dropbox.find(id)
    access_token = get_access_token(dropbox_credential.refresh_token)
    fetch_members(access_token, dropbox_credential.cred.id, limit, include_removed)
  end

  private
    def fetch_members(access_token, connection_id, limit, include_removed)
      conn = Faraday.new(url: "https://api.dropbox.com")
      response = conn.post do |req|
          req.url "/2/team/members/list_v2"
          req.headers["Authorization"] = "Bearer #{access_token}"
          req.headers["Content-Type"] = "application/json"
          req.body = { "include_removed": include_removed, "limit": limit }.to_json
      end
      if response.status == 200
        data = JSON.parse(response.body)
        account_attributes = data["members"].map do |acc|
          {
            connection_id: connection_id,
            name: acc["profile"]["name"]["display_name"],
            email: acc["profile"]["email"],
            status: acc["profile"]["status"][".tag"]
          }
        end
        Account.upsert_all(account_attributes)
        # If there are more members, use the cursor to continue fetching
        if data["has_more"]
          fetch_members_continue(access_token, data["cursor"], connection_id)
        end
      else
          raise StandardError, "Dropbox API request failed with status: #{response.status} and body: #{response.body}"
      end
    end

    def fetch_members_continue(access_token, cursor, connection_id)
      conn = Faraday.new(url: "https://api.dropboxapi.com")
      curr_cursor = cursor
      loop do
        response = conn.post do |req|
          req.url "/2/team/members/list/continue_v2"
          req.headers["Authorization"] = "Bearer #{access_token}"
          req.headers["Content-Type"] = "application/json"
          req.body = { cursor: curr_cursor }.to_json
        end

        if response.status == 200
          data = JSON.parse(response.body)
          account_attributes = data["members"].map do |acc|
            {
              connection_id: connection_id,
              name: acc["profile"]["name"]["display_name"],
              email: acc["profile"]["email"],
              status: acc["profile"]["status"][".tag"]
            }
          end
          Account.upsert_all(account_attributes)
          unless response["has_more"]
            break
          else
            curr_cursor = response["cursor"]
          end
        else
          raise StandardError, "Dropbox API request failed with status: #{response.status} and body: #{response.body}"
        end
      end
    end

    def get_access_token(refresh_token)
      conn = Faraday.new(
          url: "https://api.dropbox.com",
        )
      form_data = {
        grant_type: "refresh_token",
        refresh_token: refresh_token,
        client_id: Rails.application.credentials.dig(:dropbox, :app_key),
        client_secret: Rails.application.credentials.dig(:dropbox, :app_secret)
      }
      response_token = conn.post do |req|
          req.url "/oauth2/token"
          req.headers["Content-Type"] = "application/x-www-form-urlencoded"
          req.body = URI.encode_www_form(form_data)
      end
      access_token = JSON.parse(response_token.body)["access_token"]
      access_token
    end
end
