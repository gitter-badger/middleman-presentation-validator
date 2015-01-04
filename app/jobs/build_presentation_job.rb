require 'timeout'

class BuildPresentationJob < ActiveJob::Base
  queue_as :default

  def perform(build_job)
    directory_with_config = Dir.glob(File.join(build_job.working_directory, '**', '.middleman-presentation.yaml')).first

    cmd_str = []
    cmd_str << 'bundle exec middleman-presentation build presentation'

    if build_job.add_static_servers
      cmd_str << '--add-static-servers=true'
    else
      cmd_str << '--add-static-servers=false'
    end

    build_job.start_time = Time.now

    cmd = nil
    Timeout::timeout(Rails.configuration.x.build_timeout) do
      cmd = MiddlemanPresentationBuilder::Command.new(cmd_str.join(' '), working_directory: directory_with_config)
      cmd.execute
    end

    build_job.stop_time = Time.now
    build_job.output << format('$ %s', cmd.to_s)
    build_job.output << cmd.output

    fail "Command \"#{command.to_s}\" failed. See output for more details" unless cmd.success?

    build_job.zip! build_job
  rescue => err
    Rails.logger.debug "Build Job failed with #{err.message}\n\n#{err.backtrace.join("\n")}"
    build_job.stop_time = Time.now
    build_job.error_occured!
  end
end
