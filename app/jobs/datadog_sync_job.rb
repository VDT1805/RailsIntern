class DatadogSyncJob < ApplicationJob
  queue_as :default

  def perform(api_key:, application_key:, subdomain:, connection_id: )
      conn = Faraday.new(
        url: "https://api.datadoghq.com",
      )
      response = conn.get do |req|
        req.url "/api/v2/users"
        req.headers["Content-Type"] = "application/json"
        req.headers["DD_API_KEY"] = api_key
        req.headers["DD_APPLICATION_KEY"] = application_key #HAS TO BE DD_APPLICATION_KEY
        req.headers["DD_SITE"] = subdomain
      end
      
      data = JSON.parse(response.body)['data']
      # byebug
      # Transform data for Account model
      account_attributes = data.map do |acc|
        {
          connection_id: connection_id,
          name: acc["attributes"]["name"],
          email: acc["attributes"]["email"],
          status: acc["attributes"]["status"]
        }
      end

      # Bulk insert into Account model
      Account.insert_all(account_attributes)
  end
end
