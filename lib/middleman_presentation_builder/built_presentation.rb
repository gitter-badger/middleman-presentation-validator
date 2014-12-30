# encoding: utf-8
module MiddlemanPresentationBuilder
  class BuiltPresentation
    attr_reader :suggested_filename, :file

    def initialize(file:, suggested_filename:)
      @file          = file
      @suggested_filename = suggested_filename
    end
  end
end
