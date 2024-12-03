class PeriodicDropboxSyncJob < ApplicationJob
  queue_as :default

  def perform
    list_id = Cred.dropboxes.pluck(:credable_id)
    dropbox_jobs = []
    list_id.map do |credable_id|
      dropbox_jobs.append(DropboxSyncJob.new(credable_id, 30, true))
    end
    ActiveJob.perform_all_later(dropbox_jobs)
  end
end
