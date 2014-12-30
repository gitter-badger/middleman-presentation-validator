# encoding: utf-8
module MiddlemanPresentationBuilder
  class PresentationMetadataExtractor
    def use(directory)
      config_file = Dir.glob(File.join(directory, '**', '.middleman-presentation.yaml')).first
      config = PresentationConfig.new(config_file)

      format('%s-%s', config.date, config.title.characterize)
    end
  end
end
