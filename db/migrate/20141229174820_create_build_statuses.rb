class CreateBuildStatuses < ActiveRecord::Migration
  def change
    create_table :build_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
