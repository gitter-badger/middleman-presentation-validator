class BuildJob < ActiveRecord::Base
  belongs_to :build_status
  mount_uploader :source_file, SourceFileUploader
  mount_uploader :build_file, BuildFileUploader
end
