class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.date :date
      t.integer :status_id
      t.string :output

      t.timestamps null: false
    end
  end
end
