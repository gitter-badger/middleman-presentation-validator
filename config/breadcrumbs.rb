crumb :root do
  link "Home", root_path
end

crumb :validation_jobs do
  link I18n.t('views.application.main_navigation.links.validation_jobs'), validation_jobs_path
end

crumb :edit_validation_job do |validation_job|
  link validation_job.short_title, validation_job_path(validation_job)
  parent :validation_jobs
end

crumb :new_validation_job do |validation_job|
  link I18n.t('views.application.breadcrumbs.links.new_validation_job')
  parent :validation_jobs
end

crumb :validation_job do |validation_job|
  link validation_job.short_title, validation_job_path(validation_job)
  parent :validation_jobs
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
