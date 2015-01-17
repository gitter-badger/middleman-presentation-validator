require 'timeout'

class InstallRequirementsJob < ActiveJob::Base
  queue_as :default

  def perform(validation_job)
    directory_with_config = File.dirname(Dir.glob(File.join(validation_job.working_directory, '**', '.middleman-presentation.yaml')).first)

    Rails.logger.debug "Using directory \"#{directory_with_config}\" for job execution"
    fail "Directory \"#{directory_with_config}\" does not exist" unless File.directory? directory_with_config

    cmd = nil
    Timeout::timeout(Rails.configuration.x.build_timeout) do
      cmd = MiddlemanPresentationBuilder::Command.new('bundle install', working_directory: directory_with_config)
      cmd.execute
    end

    validation_job.output << format("$ %s\n", cmd.to_s)
    validation_job.output << cmd.output
    validation_job.output << ''

    fail "Command \"#{command.to_s}\" failed. See output for more details" unless cmd.success?

    validation_job.progress[:installing_requirements] = true
    validation_job.build! validation_job
  rescue => err
    Rails.logger.fatal "Build Job failed with #{err.message}\n\n#{err.backtrace.join("\n")}"
    validation_job.progress[:installing_requirements] = false
    validation_job.stop_time = Time.now
    validation_job.error_occured!
  end
end
