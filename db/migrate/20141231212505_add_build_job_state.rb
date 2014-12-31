class AddBuildJobState < ActiveRecord::Migration
  def change
    add_column :build_jobs, :aasm_state, :string
  end
end
