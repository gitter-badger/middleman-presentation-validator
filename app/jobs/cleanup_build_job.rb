class CleanupBuildJob < ActiveJob::Base
  queue_as :default

  def perform(build_job)
    Rails.logger.debug "Deleting working directory \"#{build_job.working_directory}\" for build ##{build_job.id}."

    begin
      FileUtils.rm_rf build_job.working_directory
      build_job.finish!(:completed, build_job)
    rescue => err
      Rails.logger.debug "Error occured while deleting working directory \"#{build_job.working_directory}\": #{err.message}\n#{err.backtrace}"
      build_job.error_occured!
    end
  end
end
