class AddCallbackUrlToBuildJob < ActiveRecord::Migration
  def change
    add_column :build_jobs, :callback_url, :string
  end
end
