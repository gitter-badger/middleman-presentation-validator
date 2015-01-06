object @build_job
attributes :id, :start_time, :stop_time, :status, :duration

node(:start_file) { |job| Base64.encode64(job.source_file_content) }
node(:build_file) { |job| Base64.encode64(job.build_file_content) }
