# encoding: utf-8
# SpecHelpers
module SpecHelpers
  # Fixtures
  module Presentations
    def presentation_fixture_path(name)
      File.expand_path("../../../fixtures/#{name}", __FILE__)
    end

    def use_fixture(name)
      FileUtils.cp_r presentation_fixture_path(name), absolute_path(name)
    end

    def source_presentation_file_for(name)
      zip_file = absolute_path("#{name}.zip")
      MiddlemanPresentationBuilder::Utils.zip(presentation_fixture_path(name), zip_file)

      zip_file
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelpers::Presentations
end
