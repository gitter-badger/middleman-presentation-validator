class CallbackUrlValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :url)
    options.reverse_merge!(registry: Rails.configuration.x.registry)

    super
  end

  def validate_each(record, attribute, value)
    return if options[:registry].blank?

    begin
      uri = Addressable::URI.parse(value)
      unless uri && uri.host && options[:registry] == uri.host
        record.errors.add(attribute, options.fetch(:message), value: value)
      end
    rescue Addressable::URI::InvalidURIError
      record.errors.add(attribute, options.fetch(:message), value: value)
    end
  end
end
