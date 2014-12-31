require 'timeout'

class BuildPresentationJob < ActiveJob::Base
  queue_as :default

  def perform(build_job)
    uploaded_presentation = MiddlemanPresentationBuilder::UploadedPresentation.new(
      build_job.source_file.file
    )
    orchestrator = MiddlemanPresentationBuilder::BuildOrchestrator.new(add_static_servers: build_job.add_static_servers)

    build_job.start_time = Time.now

    built_presentation = nil

    Timeout::timeout(Rails.configuration.x.build_timeout) do
      built_presentation, output, success = orchestrator.build(uploaded_presentation)
      build_job.stop_time    = Time.now
      build_job.build_file   = File.open(built_presentation.file)
      build_job.output       = output
      build_job.build_status = success ? BuildStatus.find_by(name: :success) : BuildStatus.find_by(name: :failure)
      build_job.save!
    end

    UploadBuiltPresentationJob.perform_later(build_job.build_file.file.file, build_job.callback_url) if build_job.callback_url
  rescue Timeout::Error
    build_job.stop_time    = Time.now
    build_job.build_status = BuildStatus.find_by(name: :failure)
    build_job.save!
  ensure
    if built_presentation.file
      Rails.logger.debug "Cleaning up temporary files #{[built_presentation.file].to_list}."
      MiddlemanPresentationBuilder::BuildCleaner.new.use(built_presentation.file)
    end
  end
end
