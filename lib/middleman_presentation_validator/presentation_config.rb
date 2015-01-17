# encoding: utf-8
module MiddlemanPresentationValidator
  class PresentationConfig
    private

    attr_reader :config_file, :data

    public

    def initialize(config_file)
      @config_file = config_file
      @data = if valid?
                Psych.load_file(config_file).deep_symbolize_keys
              else
                {}
              end
    end

    def valid?
      File.exist?(config_file)
    end

    def date
      Date.parse(data[:date]) if data[:date]
    end

    def title
      data[:title]
    end

    def to_h
      {
        date: date,
        title: title,
      }
    end
  end
end
