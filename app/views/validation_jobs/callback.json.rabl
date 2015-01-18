object @validation_job

node :valid do |job|
    if job.valid_presentation?
      'true'
    else
      'false'
    end
end
