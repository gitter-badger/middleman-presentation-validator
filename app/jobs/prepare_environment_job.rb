class PrepareEnvironmentJob < ActiveJob::Base
  queue_as :default

  def perform(validation_job)
    Rails.logger.debug "Preparing environment for running validation job ##{validation_job.id}."

    FileUtils.rm_rf validation_job.working_directory
    validation_job.progress = {}
    validation_job.progress[:preparing_environment] = true

    validation_job.unzip! validation_job
  rescue => err
    Rails.logger.warn "Deleting working directory \"#{validation_job.working_directory}\" for validation job ##{validation_job.id} failed but I cannot do anything about it."
    validation_job.progress[:preparing_environment] = false
    validation_job.output = err.message
    validation_job.stop_time = Time.now
    validation_job.error_occured!
  end
end
