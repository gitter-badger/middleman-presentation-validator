require 'rails_helper'

RSpec.describe "build_jobs/index.json.rabl", :type => [:view, :feature] do
  context '#get' do
    it 'returns json document' do
      visit '/build_jobs.json'
      binding.pry
      ''
    end
  end
end
