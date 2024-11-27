module DatadogServices
  class ListUsers
    def initialize(datadog_credential)
      @conn = Faraday.new(
        url: "https://api.datadoghq.com",
      )
      @datadog_credential = datadog_credential
    end

    def call(params = {})
      response = conn.get do |req|
        req.url "/api/v2/users?page[size]=#{params[:pagesize]}&page[number]=#{params[:page]}"
        req.headers["Content-Type"] = "application/json"
        req.headers["DD_API_KEY"] = datadog_credential.api_key
        req.headers["DD_APPLICATION_KEY"] = datadog_credential.application_key
        req.headers["DD_SITE"] = datadog_credential.subdomain
      end

      if response.status == 200
        response
      else
        raise StandardError, "Datadog API request failed with status: #{response.status} and body: #{response.body}"
      end
    end

    private
      attr_reader :conn, :datadog_credential
  end
end
