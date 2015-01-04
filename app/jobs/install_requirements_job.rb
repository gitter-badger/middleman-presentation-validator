require 'timeout'

class InstallRequirementsJob < ActiveJob::Base
  queue_as :default

  def perform(build_job)
    directory_with_config = Dir.glob(File.join(build_job.working_directory, '**', '.middleman-presentation.yaml')).first

    cmd = nil
    Timeout::timeout(Rails.configuration.x.build_timeout) do
      cmd = MiddlemanPresentationBuilder::Command.new('bundle install', working_directory: directory_with_config)
      cmd.execute
    end

    build_job.output << format('$ %s', cmd.to_s)
    build_job.output << cmd.output

    fail "Command \"#{command.to_s}\" failed. See output for more details" unless cmd.success?

    build_job.zip! build_job
  rescue => err
    Rails.logger.debug "Build Job failed with #{err.message}\n\n#{err.backtrace.join("\n")}"
    build_job.error_occured!
  end
end
