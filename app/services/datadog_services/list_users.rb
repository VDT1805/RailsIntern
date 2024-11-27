module DatadogServices
  class ListUsers
    # resource path
    VAR_PATH = "/api/v2/users"
    def initialize
      @conn = Faraday.new(
        url: "https://api.datadoghq.com",
      )
    end

    def call(params = {})
      response = @conn.get do |req|
        req.url "#{VAR_PATH}?page[size]=#{params[:pagesize]}&page[number]=#{params[:page]}"
        req.headers["Content-Type"] = "application/json"
        req.headers["DD_API_KEY"] = params[:api_key]
        req.headers["DD_APPLICATION_KEY"] = params[:application_key]
        req.headers["DD_SITE"] = params[:subdomain]
      end

      if response.status == 200
        response
      else
        raise StandardError, "Datadog API request failed with status: #{response.status} and body: #{response.body}"
      end
    end
  end
end
