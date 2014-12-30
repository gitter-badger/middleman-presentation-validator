# encoding: utf-8
module MiddlemanPresentationBuilder
  class UploadedPresentation
    attr_reader :file

    def initialize(params)
      @file = params.tempfile.path
    end
  end
end
