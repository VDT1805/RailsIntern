class DatadogSyncJob < ApplicationJob
  queue_as :default

  def perform(job)
      conn = Faraday.new(
        url: "https://api.datadoghq.com",
      )
      response = conn.get do |req|
        req.url "/api/v2/users?page[size]=#{job[:pagesize]}&page[number]=#{job[:page]}"
        req.headers["Content-Type"] = "application/json"
        req.headers["DD_API_KEY"] = job[:datadog_credential].api_key
        req.headers["DD_APPLICATION_KEY"] = job[:datadog_credential].application_key
        req.headers["DD_SITE"] = job[:datadog_credential].subdomain
      end
      if response.status == 200
            data = JSON.parse(response.body)["data"]
            account_attributes = data.map do |acc|
              {
                connection_id: job[:datadog_credential].cred.connection_id,
                name: acc["attributes"]["name"],
                email: acc["attributes"]["email"],
                status: acc["attributes"]["status"]
              }
            end
            Account.upsert_all(account_attributes)
      else
          raise StandardError, "Datadog API request failed with status: #{response.status} and body: #{response.body}"
      end
  end
end
