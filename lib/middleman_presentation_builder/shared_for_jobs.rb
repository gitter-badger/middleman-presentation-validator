# encoding: utf-8
module MiddlemanPresentationBuilder
  module SharedForJobs
    def presentation_root(build_job)
      file = Dir.glob(File.join(build_job.working_directory, '**', '.middleman-presentation.yaml')).first

      return unless file

      File.dirname(file)
    end
  end
end
