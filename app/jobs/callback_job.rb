class CallbackJob < ActiveJob::Base
  queue_as :default

  def perform(validation_job)
    if validation_job.callback_url.blank?
      validation_job.cleanup! validation_job
      return
    end

    Rails.logger.debug "Calling back \"#{validation_job.callback_url}\"."

    template = Tilt::JbuilderTemplate.new(Rails.root.join('app/views/validation_jobs/callback.json.jbuilder').to_s)
    json     = template.render(validation_job)

    transferrer = MiddlemanPresentationValidator::Uploader.new
    transferrer.upload validation_job.callback_url, json

    validation_job.progress[:calling_back] = true

    validation_job.cleanup! validation_job
  rescue => err
    Rails.logger.fatal "Error occured while calling back: #{err.message}\n#{err.backtrace.join("\n")}"
    validation_job.progress[:calling_back] = false
    validation_job.output = err.message
    validation_job.stop_time = Time.now
    validation_job.error_occured!
  end
end
