class BatchDatadogSyncJob < ApplicationJob
  queue_as :default
  discard_on StandardError
  def perform(job)
    # Do something later
    datadog_credential = Datadog.find(job[:connection_id])
    conn = Faraday.new(
        url: "https://api.datadoghq.com",
      )
    response = conn.get do |req|
        req.url "/api/v2/users?page[size]=1&page[number]=0"
        req.headers["Content-Type"] = "application/json"
        req.headers["DD_API_KEY"] = datadog_credential.api_key
        req.headers["DD_APPLICATION_KEY"] = datadog_credential.application_key
        req.headers["DD_SITE"] = datadog_credential.subdomain
      end
    if response.status == 200
        total_count = JSON.parse(response.body)["meta"]["page"]["total_count"]
        pagesize = 50
        total_pages = (total_count.to_f / pagesize).ceil
        datadog_sync_jobs = [] 
        total_pages.times do |page|
          datadog_sync_jobs.append(DatadogSyncJob.new(
            datadog_credential: datadog_credential,
            pagesize: pagesize, page: page))
        end
        ActiveJob.perform_all_later(datadog_sync_jobs)
    else
        raise StandardError, "Datadog API request failed with status: #{response.status} and body: #{response.body}"
    end
  end
end
