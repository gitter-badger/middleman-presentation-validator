# encoding: utf-8
module MiddlemanPresentationBuilder
  class BuiltPresentation
    private

    attr_reader :directory

    public

    attr_reader :suggested_filename, :file

    def initialize(directory:, suggested_filename:)
      @directory          = directory
      @suggested_filename = suggested_filename
      @file               = File.join(Dir.tmpdir, sprintf('presentation-%s.build.zip', SecureRandom.hex))
    end

    def zip
      Utils.zip(directory, file, prefix: suggested_filename)
    end
  end
end
