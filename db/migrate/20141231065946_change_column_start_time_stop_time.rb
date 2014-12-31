class ChangeColumnStartTimeStopTime < ActiveRecord::Migration
  def change
    change_column :build_jobs, :start_time, :datetime
    change_column :build_jobs, :stop_time, :datetime
  end
end
