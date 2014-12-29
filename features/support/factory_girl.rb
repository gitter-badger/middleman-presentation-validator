require 'factory_girl'
FactoryGirl.definition_file_paths = [Rails.root.join('fixtures')]
FactoryGirl.find_definitions

World(FactoryGirl::Syntax::Methods)
