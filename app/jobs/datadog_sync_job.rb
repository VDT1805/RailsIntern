class DatadogSyncJob < ApplicationJob
  queue_as :default

  def perform(job)
      conn = Faraday.new(
        url: "https://api.datadoghq.com",
      )
      response = conn.get do |req|
        req.url "/api/v2/users"
        req.headers["Content-Type"] = "application/json"
        req.headers["DD_API_KEY"] = job[:api_key]
        req.headers["DD_APPLICATION_KEY"] = job[:application_key] # HAS TO BE DD_APPLICATION_KEY
        req.headers["DD_SITE"] = job[:subdomain]
      end

      if response.status == 200
            data = JSON.parse(response.body)["data"]

            # Transform data for Account model
            account_attributes = data.map do |acc|
              {
                connection_id: job[:connection_id],
                name: acc["attributes"]["name"],
                email: acc["attributes"]["email"],
                status: acc["attributes"]["status"]
              }
            end

            # Bulk insert into Account model
            Account.insert_all(account_attributes)
      else
          # Raise an error for non-successful status codes
          raise StandardError, "Datadog API request failed with status: #{response.status} and body: #{response.body}"
      end
  end
end
