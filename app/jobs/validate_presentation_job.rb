class ValidatePresentationJob < ActiveJob::Base
  queue_as :default

  def perform(build_job)
    test is_zip_file?(build_job.source_file.file.file), 'No zip file'
    test has_gemfile?(build_job.working_directory), 'No gemfile found'
    test has_middleman_gem_in_gemfile?(build_job.working_directory), 'No middleman gem in Gemfile'
    test has_middleman_config_file?(build_job.working_directory), 'No middleman config file'

    build_job.install! build_job
  end

  private

  def test(check, message)
    unless check
      Rails.logger.debug "Error occured while validating \"#{build_job.source_file.file.file}\": #{message}"
      build_job.error_occured!
    end
  end

  def is_zip_file?(file)
    /Zip archive/ === FileMagic.new.file(file)
  end

  def has_middleman_gem_in_gemfile?(directory)
    return false unless has_gemfile?(directory)

    gem_file = Dir.glob(File.join(directory, '**', 'Gemfile')).first

    !File.read(gem_file)[/gem ["']middleman-presentation["']/].blank?
  end

  def has_middleman_config_file?(directory)
    !Dir.glob(File.join(directory, '**', '.middleman-presentation.yaml')).first.blank?
  end

  def has_gemfile?(directory)
    !Dir.glob(File.join(directory, '**', 'Gemfile')).first.blank?
  end
end
