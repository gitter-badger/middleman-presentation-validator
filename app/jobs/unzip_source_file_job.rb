class UnzipSourceFileJob < ActiveJob::Base
  queue_as :default

  def perform(build_job)
    zip_file = build_job.source_file.file.file

    Rails.logger.debug "Unzipping presentation \"#{zip_file}\"."

    begin
      Utils.unzip(zip_file, build_job.working_directory)
      build_job.validate!(:validated, build_job)
    rescue => err
      Rails.logger.debug "Error occured while unzipping \"#{zip_file}\": #{err.message}\n#{err.backtrace}"
      build_job.error_occured!
    end
  end
end
