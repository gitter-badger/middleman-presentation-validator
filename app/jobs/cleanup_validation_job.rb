class CleanupValidationJob < ActiveJob::Base
  queue_as :default

  def perform(validation_job)
    Rails.logger.debug "Deleting working directory \"#{validation_job.working_directory}\" for build ##{validation_job.id}."

    FileUtils.rm_rf validation_job.working_directory
    validation_job.save!

    validation_job.progress[:cleaning_up] = true
    validation_job.stop_time = Time.now
    validation_job.finish! validation_job
  rescue => err
    Rails.logger.fatal "Validation Job failed with #{err.message}\n\n#{err.backtrace.join("\n")}"
    validation_job.progress[:cleaning_up] = false
    validation_job.stop_time = Time.now
    validation_job.error_occured!
  end
end
