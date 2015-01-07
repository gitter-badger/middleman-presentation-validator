require 'rails_helper'

RSpec.describe BuildJob, :type => :model do
  context '#to_json' do
    it 'serianlizes object to json' do
      build_job = FactoryGirl.build(:build_job).decorate
      hash = JSON.parse(build_job.to_json)

      expect(hash['output']).to eq 'hello world'
    end
  end
end
