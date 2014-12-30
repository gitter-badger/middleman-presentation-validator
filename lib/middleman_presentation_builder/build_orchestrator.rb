# encoding: utf-8
module MiddlemanPresentationBuilder
  class BuildOrchestrator
    private

    attr_reader :unzipper, :zipper, :validator, :builder, :metadata_extractor, :creator

    public

    def initialize(add_static_servers:)
      @unzipper           = PresentationUnzipper.new
      @validator          = PresentationValidator.new
      @zipper             = PresentationZipper.new
      @builder            = PresentationBuilder.new(add_static_servers: add_static_servers)
      @metadata_extractor = PresentationMetadataExtractor.new
      @creator            = BuiltPresentation
    end

    def build(uploaded_presentation)
      Rails.logger.debug "Unzipping presentation \"#{uploaded_presentation.file}\"."
      temporary_directory = unzipper.use(uploaded_presentation.file)

      Rails.logger.debug "Validating presentation \"#{uploaded_presentation.file}\" and temporary directory \"#{temporary_directory}\"."
      is_valid = validator.use(uploaded_presentation.file, temporary_directory)

      Rails.logger.debug "Extracting suggested filename from config file."
      suggested_filename = metadata_extractor.use(temporary_directory)

      fail unless is_valid == true

      Rails.logger.debug "Building presentation in \"#{temporary_directory}\"."
      build_directory, output, success = builder.use(temporary_directory)

      Rails.logger.debug "Zipping built presentation in \"#{build_directory}\" and use suggested file \"#{suggested_filename}\"."
      zip_file = zipper.use(build_directory, suggested_filename)

      [creator.new(file: zip_file, suggested_filename: suggested_filename), output, success]
    rescue StandardError
      fail
    end
  end
end
