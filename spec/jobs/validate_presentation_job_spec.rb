require 'rails_helper'

RSpec.describe ValidatePresentationJob, :type => :job do
  context '#perform' do
    it 'detects a valid presentation source file' do
      model = instance_double('BuildJob')
      expect(model).to receive(:install)
      allow(model).to receive(:source_file)

      job = ValidatePresentationJob.new
      job.perform(model)
    end
  end
end
