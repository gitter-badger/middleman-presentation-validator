class BuildJob < ActiveRecord::Base
  include AASM

  belongs_to :build_status
  mount_uploader :source_file, SourceFileUploader
  mount_uploader :build_file, BuildFileUploader

  aasm :column => :state, :enum => true do
    state :created, :initial => true
    state :unzipped
    state :built
    state :zipped
    state :validated
    state :transferred
    state :success
    state :failure

    event :build_it do
      transitions :from => :created, :to => :building
    end

    event :failed do
      transitions :from => :building, :to => :failure
    end

    event :successful do
      transitions :from => :building, :to => :success
    end
  end
end
