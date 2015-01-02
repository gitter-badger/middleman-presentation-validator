class RemoveColumnBuildStatusId < ActiveRecord::Migration
  def change
    remove_column :build_jobs, :build_status_id
  end
end
