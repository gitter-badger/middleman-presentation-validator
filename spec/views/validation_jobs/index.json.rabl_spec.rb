require 'rails_helper'

RSpec.describe "validation_jobs/index.json.rabl", :type => [:view, :feature] do
  context '#get' do
    it 'returns json document' do
      visit '/validation_jobs.json'
      binding.pry
      ''
    end
  end
end
