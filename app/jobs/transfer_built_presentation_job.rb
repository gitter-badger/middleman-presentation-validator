class TransferBuiltPresentationJob < ActiveJob::Base
  queue_as :default

  def perform(build_job)
    unless build_job.callback_url
      build_job.cleanup!(:clean, build_job)
      return
    end

    Rails.logger.debug "Transferring presentation to \"#{build_job.callback_url}\"."

    begin
      transferrer = MiddlemanPresentationBuilder::Uploader.new
      transferrer.upload build_job.callback_url, build_job.build_file.file.file
      build_job.cleanup! build_job
    rescue => err
      Rails.logger.debug "Error occured while transferring presentation: #{err.message}\n#{err.backtrace.join("\n")}"
      build_job.error_occured!
    end
  end
end
