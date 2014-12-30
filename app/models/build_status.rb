class BuildStatus < ActiveRecord::Base
  has_many :build_jobs
end
