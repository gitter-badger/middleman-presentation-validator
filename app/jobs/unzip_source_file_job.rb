class UnzipSourceFileJob < ActiveJob::Base
  queue_as :default

  def perform(validation_job)
    validation_job.start_time = Time.now

    fail 'No source file was uploaded' if validation_job.source_file.blank? || validation_job.source_file.file.blank?

    zip_file = validation_job.source_file.file.file

    Rails.logger.debug "Unzipping presentation \"#{zip_file}\" to \"#{validation_job.working_directory}\"."

    MiddlemanPresentationValidator::Utils.unzip(zip_file, validation_job.working_directory)

    validation_job.progress[:unzipping] = true

    validation_job.validate! validation_job
  rescue => err
    Rails.logger.fatal "Error occured while unzipping \"#{zip_file}\": #{err.message}\n#{err.backtrace.join("\n")}"
    validation_job.progress[:unzipping] = false
    validation_job.stop_time = Time.now
    validation_job.error_occured!
  end
end
