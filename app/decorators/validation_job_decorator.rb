require 'fedux_org_stdlib/icon'

class ValidationJobDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def icon
    FeduxOrgStdlib::Icon.new(id.to_s).to_data_uri
  end

  def source_file_size
    return if source_file.blank?

    format '(%s)', h.number_to_human_size(source_file.size, precision: 2)
  end

  def validation_status(status = aasm_state.to_sym)
    case status
    when :created
      I18n.t('views.validation_jobs.validation_status.created')
    when :preparing_environment
      I18n.t('views.validation_jobs.validation_status.preparing_environment')
    when :unzipping
      I18n.t('views.validation_jobs.validation_status.unzipping')
    when :validating
      I18n.t('views.validation_jobs.validation_status.validating')
    when :cleaning_up
      I18n.t('views.validation_jobs.validation_status.cleaning_up')
    when :calling_back
      I18n.t('views.validation_jobs.validation_status.calling_back')
    when :failed
      I18n.t('views.validation_jobs.validation_status.failed')
    when :completed
      I18n.t('views.validation_jobs.validation_status.completed')
    else
      fail "Invalid state #{aasm_state}"
    end
  end

  def source_file_content
    return if source_file.blank?

    source_file.read
  end

  def title
    format('%s #%d', ValidationJob.model_name.human, id)
  end

  def short_title
    format('#%d', id)
  end

  def duration
    return 0 if stop_time.blank? || start_time.blank?

    Time.at(stop_time - start_time).utc.strftime("%H:%M:%S")
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
