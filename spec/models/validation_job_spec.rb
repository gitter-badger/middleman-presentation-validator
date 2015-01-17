require 'rails_helper'

RSpec.describe ValidationJob, :type => :model do
  context '#to_json' do
    it 'serianlizes object to json' do
      validation_job = FactoryGirl.build(:validation_job).decorate
      hash = JSON.parse(validation_job.to_json)

      expect(hash['output']).to eq 'hello world'
    end
  end
end
