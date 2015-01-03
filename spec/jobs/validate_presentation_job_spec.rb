# encoding: utf-8
require 'spec_helper'
require 'rails_helper'

RSpec.describe ValidatePresentationJob, :type => :job do
  context '#perform' do
    it 'detects a valid presentation source file' do
      zip_file = source_presentation_file_for('simple1')
      use_fixture('simple1')

      file = double('UploadedFile')
      allow(file).to receive(:file).and_return(zip_file)

      uploader = double('Uploader')
      allow(uploader).to receive(:file).and_return(file)

      build_job = instance_double('BuildJob')
      allow(build_job).to receive(:source_file).and_return(uploader)
      allow(build_job).to receive(:working_directory).and_return(Dir.getwd)
      expect(build_job).to receive(:install!)
      expect(build_job).not_to receive(:error_occured!)

      job = ValidatePresentationJob.new

      in_current_dir do
        job.perform(build_job)
      end
    end

    it 'detects a missing gemfile' do
      zip_file = source_presentation_file_for('simple1')
      use_fixture('simple1')
      remove_file 'Gemfile'

      file = double('UploadedFile')
      allow(file).to receive(:file).and_return(zip_file)

      uploader = double('Uploader')
      allow(uploader).to receive(:file).and_return(file)

      build_job = instance_double('BuildJob')
      allow(build_job).to receive(:source_file).and_return(uploader)
      allow(build_job).to receive(:working_directory).and_return(Dir.getwd)
      expect(build_job).to receive(:install!)
      expect(build_job).not_to receive(:error_occured!)

      job = ValidatePresentationJob.new

      in_current_dir do
        job.perform(build_job)
      end
    end
  end
end
