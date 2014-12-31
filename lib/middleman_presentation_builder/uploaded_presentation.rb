# encoding: utf-8
module MiddlemanPresentationBuilder
  class UploadedPresentation
    attr_reader :file

    def initialize(uploaded_file)
      @file = uploaded_file.file
    end
  end
end
