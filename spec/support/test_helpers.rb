# encoding: utf-8
require 'middleman-presentation-helpers/test_helpers'

RSpec.configure do |config|
  config.include Middleman::Presentation::Helpers::Test

  config.before(:each) do
    restore_env
    clean_current_dir
  end
end
