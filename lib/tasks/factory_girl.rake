require Rails.root.join('config/environment')

namespace :factory_girl do
  desc 'Lint all factories and clear db afterwards'
  task lint: %i(establish_connection_to_database) do
    DatabaseCleaner.start
    FactoryGirl.lint
    DatabaseCleaner.clean
  end

  desc 'Load all factories in db'
  task load: %i(establish_connection_to_database) do
    DatabaseCleaner.clean
    FactoryGirl.create :presentation
  end

  task establish_connection_to_database: :load_config do
    ActiveRecord::Base.establish_connection(configs_for_environment.first)
  end

  task :load_config do
    ActiveRecord::Base.configurations = Rails.application.config.database_configuration
    ActiveRecord::Migrator.migrations_paths = Rails.application.paths['db/migrate'].to_a

    if defined?(ENGINE_PATH) && engine = Rails::Engine.find(ENGINE_PATH)
      if engine.paths['db/migrate'].existent
        ActiveRecord::Migrator.migrations_paths += engine.paths['db/migrate'].to_a
      end
    end
  end
end

def configs_for_environment
  environments = [Rails.env]
  environments << 'test' if Rails.env.development?
  ActiveRecord::Base.configurations.values_at(*environments).compact.reject { |config| config['database'].blank? }
end
