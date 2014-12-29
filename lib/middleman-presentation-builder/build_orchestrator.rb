# encoding: utf-8
module MiddlemanPresentationBuilder
  class BuildOrchestrator
    def build(uploaded_presentation)
      fail unless uploaded_presentation.valid?

      uploaded_presentation.unzip

      fail unless uploaded_presentation.unzip?

      built_presentation = uploaded_presentation.build
      built_presentation.zip

      built_presentation
    end
  end
end
