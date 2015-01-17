module ValidationJobsHelper
  def progress_bar
    template_string = <<-EOS.strip_heredoc
    <ul class="fe-progress">
      <% validation_job.progress.each do |key, value| -%>
      <li class="fe-progress-item">
        <i class="fe-icon fe-icon-start fe-icon-color-grey fe-icon-validation_job-<%= key %>"></i>
        <% if value == true -%>
        <i class="fe-icon fe-icon-start fe-icon-color-grey fe-icon-validation_job-passed"></i>
        <% elsif value == false -%>
        <i class="fe-icon fe-icon-start fe-icon-color-grey fe-icon-validation_job-failure"></i>
        <% else -%>
        <i class="fe-icon fe-icon-start fe-icon-color-grey fe-icon-validation_job-not-run"></i>
        <% end -%>
      </li>
      <% end -%>
    </ul>
    EOS

    Tilt::ErubisTemplate.new { template_string }.render(validation_job: @validation_job)
  end
end
