class BatchDatadogSyncJob < ApplicationJob
  queue_as :default
  PAGESIZE = 50
  def perform(job)
      datadog_credential = Datadog.find(job[:id])
      response = DatadogServices::ListUsers.new.call(
        api_key: datadog_credential.api_key,
        application_key: datadog_credential.application_key,
        subdomain: datadog_credential.subdomain,
        pagesize: job[:pagesize] || 100,
        page: job[:page] || 0
    )
    total_count = JSON.parse(response.body)["meta"]["page"]["total_count"]
    total_pages = (total_count.to_f / PAGESIZE).ceil
    datadog_sync_jobs = []
    total_pages.times do |page|
      datadog_sync_jobs.append(DatadogSyncJob.new(
        id: job[:id],
        pagesize: PAGESIZE, page: page))
    end
    ActiveJob.perform_all_later(datadog_sync_jobs)
  end
end
