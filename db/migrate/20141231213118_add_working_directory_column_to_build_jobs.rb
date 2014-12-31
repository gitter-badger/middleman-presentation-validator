class AddWorkingDirectoryColumnToBuildJobs < ActiveRecord::Migration
  def change
    add_column :build_jobs, :working_directory, :string
  end
end
