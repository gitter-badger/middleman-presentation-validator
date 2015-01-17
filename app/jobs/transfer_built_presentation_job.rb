class TransferBuiltPresentationJob < ActiveJob::Base
  queue_as :default

  def perform(validation_job)
    unless validation_job.callback_url
      validation_job.cleanup!(:clean, validation_job)
      return
    end

    Rails.logger.debug "Transferring presentation to \"#{validation_job.callback_url}\"."

    transferrer = MiddlemanPresentationBuilder::Uploader.new
    transferrer.upload validation_job.callback_url, validation_job.to_json

    validation_job.progress[:transferring] = true

    validation_job.cleanup! validation_job
  rescue => err
    Rails.logger.fatal "Error occured while transferring presentation: #{err.message}\n#{err.backtrace.join("\n")}"
    validation_job.progress[:transferring] = false
    validation_job.stop_time = Time.now
    validation_job.error_occured!
  end
end
