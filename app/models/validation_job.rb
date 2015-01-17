class ValidationJob < ActiveRecord::Base
  include AASM

  attachment :source_file

  store :progress

  belongs_to :build_status
  has_one :build_progress

  aasm do
    state :created, initial: true
    state :unzipping, after_enter: :unzip_source_file
    state :validating, after_enter: :validate_presentation
    state :cleaning_up, after_enter: :cleanup_validation_job
    state :failed
    state :completed

    event :unzip do
      transitions from: :created, to: :unzipping
    end

    event :validate do
      transitions from: :unzipping, to: :validating
    end

    event :cleanup do
      transitions from: :validating, to: :cleaning_up
    end

    event :finish do
      transitions from: :cleaning_up, to: :completed
    end

    event :error_occured do
      transitions to: :failed
    end

    event :restart do
      transitions to: :created
    end
  end

  def to_json
    template = 'validation_jobs/show'
    object = self
    Rabl.render(object, template, :view_path => 'app/views', :format => :json)
  end

  private

  def unzip_source_file
    UnzipSourceFileJob.perform_later(self)
  end

  def validate_presentation
    ValidatePresentationJob.perform_later(self)
  end

  def cleanup_validation_job
    CleanupValidationJob.perform_later(self)
  end
end
