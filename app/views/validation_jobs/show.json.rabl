object @validation_job
attributes :id, :start_time, :stop_time, :validation_status, :duration

node(:start_file) do |job| 
  if job.source_file.blank?
    ""
  else
    Base64.encode64(job.source_file.read)
  end
end
