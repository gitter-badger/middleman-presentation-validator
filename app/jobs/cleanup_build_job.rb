class CleanupBuildJob < ActiveJob::Base
  queue_as :default

  def perform(build_job)
    Rails.logger.debug "Deleting working directory \"#{build_job.working_directory}\" for build ##{build_job.id}."

    FileUtils.rm_rf build_job.working_directory
    build_job.finish! build_job
  end
end
