class DeleteTableStatuses < ActiveRecord::Migration
  def change
    drop_table :build_statuses
    drop_table :statuses
  end
end
