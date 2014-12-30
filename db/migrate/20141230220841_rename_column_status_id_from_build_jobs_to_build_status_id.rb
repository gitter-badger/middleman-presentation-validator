class RenameColumnStatusIdFromBuildJobsToBuildStatusId < ActiveRecord::Migration
  def change
    rename_column :build_jobs, :status_id, :build_status_id
  end
end
