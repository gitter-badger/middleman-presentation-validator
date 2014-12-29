# encoding: utf-8
module MiddlemanPresentationBuilder
  class UploadedPresentation
    private

    attr_reader :params, :build_directory, :add_static_servers

    public

    def initialize(params, add_static_servers:)
      @params             = params
      @build_directory    = Dir.mktmpdir('presentation')
      @add_static_servers = add_static_servers
    end

    def unzip
      Utils.unzip(file, build_directory)
    end

    def build
      builder = PresentationBuilder.new(presentation_directory, add_static_servers: add_static_servers)
      builder.run

      BuiltPresentation.new(directory: File.join(presentation_directory, 'build'), suggested_filename: suggested_filename)
    end

    def valid?
      !params.blank? && !params[:tempfile].blank?
    end

    def unzip?
      !presentation_directory.blank?
    end

    private

    def suggested_filename
      config = PresentationConfig.new(config_file)
      format('%s-%s', config.date, config.title.characterize)
    end

    def presentation_directory
      return unless config_file

      File.dirname(config_file)
    end

    def file
      params[:tempfile].path
    end

    def config_file
      Dir.glob(File.join(build_directory, '**', '.middleman-presentation.yaml')).first
    end
  end
end
