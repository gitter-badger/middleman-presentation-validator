class AddColumsStartTimeStopTimeToBuildJob < ActiveRecord::Migration
  def change
    change_table :build_jobs do |t|
      t.time :start_time
      t.time :stop_time
      t.remove :date
      t.string :source_file
      t.string :build_file
      t.boolean :add_static_servers
    end
  end
end
