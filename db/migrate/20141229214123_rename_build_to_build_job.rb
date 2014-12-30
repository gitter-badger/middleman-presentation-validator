class RenameBuildToBuildJob < ActiveRecord::Migration
  def change
    rename_table :builds, :build_jobs
  end
end
