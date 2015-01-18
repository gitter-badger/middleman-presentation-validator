class ValidationJob < ActiveRecord::Base
  include AASM

  attachment :source_file

  store :progress

  belongs_to :validation_status
  has_one :build_progress

  validates :source_file, presence: true
  validates :callback_url, url: { allow_blank: true }

  aasm do
    state :created, initial: true
    state :preparing_environment, after_enter: :prepare_environment
    state :unzipping, after_enter: :unzip_source_file
    state :validating, after_enter: :validate_presentation
    state :cleaning_up, after_enter: :cleanup_validation_job
    state :calling_back, after_enter: :callback_consumer
    state :failed, after_enter: :failure_cleanup_job
    state :completed

    event :prepare_environment do
      transitions from: :created, to: :preparing_environment
    end

    event :unzip do
      transitions from: :preparing_environment, to: :unzipping
    end

    event :validate do
      transitions from: :unzipping, to: :validating
    end

    event :callback do
      transitions from: :validating, to: :calling_back
    end

    event :cleanup do
      transitions from: :calling_back, to: :cleaning_up
    end

    event :complete do
      transitions from: :cleaning_up, to: :completed
    end

    event :error_occured do
      transitions to: :failed
    end

    event :restart do
      transitions to: :preparing_environment
    end
  end

  private

  def prepare_environment
    PrepareEnvironmentJob.perform_later(self)
  end

  def unzip_source_file
    UnzipSourceFileJob.perform_later(self)
  end

  def validate_presentation
    ValidatePresentationJob.perform_later(self)
  end

  def callback_consumer
    CallbackJob.perform_later(self)
  end

  def cleanup_validation_job
    CleanupValidationJob.perform_later(self)
  end

  def failure_cleanup_job
    FailureCleanupJob.perform_later(self)
  end
end
