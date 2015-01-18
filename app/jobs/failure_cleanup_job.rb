class FailureCleanupJob < ActiveJob::Base
  queue_as :default

  def perform(validation_job)
    Rails.logger.debug "Deleting working directory \"#{validation_job.working_directory}\" for validation job ##{validation_job.id}."

    FileUtils.rm_rf validation_job.working_directory
  rescue
    Rails.logger.warn "Deleting working directory \"#{validation_job.working_directory}\" for validation job ##{validation_job.id} failed but I cannot do anything about it."
  end
end
