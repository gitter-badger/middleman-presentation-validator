class InstallRequirementsJob < ActiveJob::Base
  queue_as :default

  def perform(build_job)
    directory_with_gemfile = File.dirname(Dir.glob(File.join(build_job.working_directory, '**', 'Gemfile')).first)

    cmd = MiddlemanPresentationBuilder::Command.new('bundle install', working_directory: directory_with_gemfile)
    cmd.execute

    build_job.output << format('$ %s', cmd.to_s)
    build_job.output << cmd.output

    build_job.save!

    if cmd.success?
      build_job.build! build_job
    else
      build_job.error_occured!
    end
  end
end
