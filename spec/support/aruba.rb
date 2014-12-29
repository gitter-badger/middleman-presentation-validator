require 'aruba/api'
require 'aruba/reporting'

# Spec Helpers
module SpecHelper
  # Helpers for aruba
  module Aruba
    include ::Aruba::Api

    def dirs
      @dirs ||= %w(tmp rspec)
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelper::Aruba

  config.before(:each) do
    restore_env
    clean_current_dir
  end
end
