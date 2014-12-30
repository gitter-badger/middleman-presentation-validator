# encoding: utf-8
module MiddlemanPresentationBuilder
  class PresentationValidator
    def use(zip_file, presentation_directory)
      is_zip_file?(zip_file) && \
        has_gemfile?(presentation_directory) && \
        has_middleman_gem_in_gemfile?(presentation_directory) && \
        has_middleman_config_file?(presentation_directory)
    end

    private

    def is_zip_file?(file)
       /Zip archive/ === FileMagic.new.file(file)
    end

    def has_middleman_gem_in_gemfile?(directory)
      return false unless has_gemfile?(directory)

      gem_file = Dir.glob(File.join(directory, '**', 'Gemfile')).first

      !File.read(gem_file)[/gem ["']middleman-presentation["']/].blank?
    end

    def has_middleman_config_file?(directory)
      !Dir.glob(File.join(directory, '**', '.middleman-presentation.yaml')).first.blank?
    end

    def has_gemfile?(directory)
      !Dir.glob(File.join(directory, '**', 'Gemfile')).first.blank?
    end
  end
end
