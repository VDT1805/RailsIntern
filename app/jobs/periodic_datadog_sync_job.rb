class PeriodicDatadogSyncJob < ApplicationJob
  queue_as :default

  def perform
    list_id = Cred.datadogs.pluck(:credable_id)
    datadog_jobs = []
    list_id.map do |credable_id|
      datadog_jobs.append(BatchDatadogSyncJob.new(id: credable_id))
    end
    ActiveJob.perform_all_later(datadog_jobs)
  end
end
