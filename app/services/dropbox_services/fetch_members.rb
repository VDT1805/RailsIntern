module DropboxServices
  class FetchMembers
    def initialize
      @conn = Faraday.new(
        url: "https://api.dropbox.com",
      )
    end
    def fetch_members(access_token:, limit:, include_removed:)
      response = @conn.post do |req|
          req.url "/2/team/members/list_v2"
          req.headers["Authorization"] = "Bearer #{access_token}"
          req.headers["Content-Type"] = "application/json"
          req.body = { "include_removed": include_removed, "limit": limit }.to_json
      end
      if response.status == 200
        response
      else
          raise StandardError, "Dropbox API request failed with status: #{response.status} and body: #{response.body}"
      end
    end

    def fetch_members_continue(access_token:, cursor:)
        response = @conn.post do |req|
          req.url "/2/team/members/list/continue_v2"
          req.headers["Authorization"] = "Bearer #{access_token}"
          req.headers["Content-Type"] = "application/json"
          req.body = { cursor: cursor }.to_json
        end
        if response.status == 200
          response
        else
          raise StandardError, "Dropbox API request failed with status: #{response.status} and body: #{response.body}"
        end
    end
  end
end
