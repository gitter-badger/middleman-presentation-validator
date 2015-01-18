class ValidatePresentationJob < ActiveJob::Base
  queue_as :default

  def perform(validation_job)

    zip_file = validation_job.source_file.to_io.path

    test zip_file_exist?(zip_file), 'Zip file does not exist'
    test is_zip_file?(zip_file), 'No zip file'
    test has_gemfile?(validation_job.working_directory), 'No gemfile found'
    test has_date?(validation_job.working_directory), 'Mandatory option date is missing'
    test has_middleman_gem_in_gemfile?(validation_job.working_directory), 'No middleman gem in Gemfile'
    test has_middleman_config_file?(validation_job.working_directory), 'No middleman config file'

    validation_job.progress[:validating] = true
    validation_job.valid_presentation = true

    validation_job.callback! validation_job
  rescue => err
    Rails.logger.fatal "Error occured while validating \"#{zip_file}\": #{err.message}\n\n#{err.backtrace.join("\n")}"
    validation_job.progress[:validating] = false
    validation_job.valid_presentation = false
    validation_job.output = err.message
    validation_job.stop_time = Time.now
    validation_job.error_occured!
  end

  private

  def test(check, message)
    fail message unless check
  end

  def zip_file_exist?(file)
    File.file? file
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

  def has_date?(directory)
    config_file = Dir.glob(File.join(directory, '**', '.middleman-presentation.yaml')).first
    config = MiddlemanPresentationValidator::PresentationConfig.new(config_file)

    !config.date.blank?
  end

  def has_gemfile?(directory)
    !Dir.glob(File.join(directory, '**', 'Gemfile')).first.blank?
  end
end
