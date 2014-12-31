class BuildJob < ActiveRecord::Base
  include AASM

  belongs_to :build_status
  mount_uploader :source_file, SourceFileUploader
  mount_uploader :build_file, BuildFileUploader

  aasm do
    state :created, initial: true, after_enter: :unzip_source_file
    state :unzipped, after_enter: :validate_presentation
    state :validated, after_enter: :build_presentation
    state :requirements_installed, after_enter: :install_requirements
    state :built, after_enter: :build_presentation
    state :zipped, after_enter: :zip_presentation
    state :transferred, after_enter: :transfer_built_presentation
    state :clean, after_enter: :cleanup_build_job
    state :completed
    state :failure, after_enter: :cleanup_build_job

    event :unzip do
      transitions from: :created, to: :unzipped
    end

    event :validate do
      transitions from: :unzipped, to: :validated
    end

    event :install do
      transitions from: :validated, to: :requirements_installed
    end

    event :build do
      transitions from: :validated, to: :built
    end

    event :zip do
      transitions from: :built, to: :zipped
    end

    event :transfer do
      transitions from: :zipped, to: :transferred
    end

    event :cleanup do
      transitions from: :transfered, to: :clean
    end

    event :finish do
      transitions from: :clean, to: :completed
    end

    event :error_occured do
      transitions to: :failure
    end
  end

  private

  def unzip_source_file(instance)
    UnzipSourceFileJob.perform_later(instance)
  end

  def validate_presentation(instance)
    ValidatePresentationJob.perform_later(instance)
  end

  def build_presentation(instance)
    BuildPresentationJob.perform_later(instance)
  end

  def zip_presentation(instance)
    ZipPresentationJob.perform_later(instance)
  end

  def transfer_built_presentation(instance)
    TransferBuiltPresentationJob.perform_later(instance)
  end

  def install_requirements(instance)
    InstallRequirementsJob.perform_later(instance)
  end

  def cleanup_build_job(instance)
    CleanupBuildJob.perform_later(instance)
  end
end
