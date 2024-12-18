class DatadogSyncJob < ApplicationJob
  queue_as :default

  def perform(job)
      datadog_credential = Datadog.find(job[:id])
      credential = Cred.datadogs.find_by(credable_id: job[:id])
      response = DatadogServices::ListUsers.new(datadog_credential).call(
        pagesize: job[:pagesize],
        page: job[:page]
      )
      account_attributes = JSON.parse(response.body)["data"].map do |acc|
        {
          third_party_id: acc["id"],
          connection_id: credential.connection_id,
          name: acc["attributes"]["name"],
          email: acc["attributes"]["email"],
          status: acc["attributes"]["status"]
        }
      end

      Account.upsert_all(account_attributes)
  end
end
