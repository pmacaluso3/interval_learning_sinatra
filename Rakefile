require_relative 'app'

envs = %w(development test)

namespace :db do
  task :create do
    envs.each do |env|
      system("createdb #{Sinatra::Application.app_name}_#{env}")
    end
  end

  task :drop do
    envs.each do |env|
      system("dropdb #{Sinatra::Application.app_name}_#{env}")
    end
  end

  task :migrate do
    ActiveRecord::Migrator.migrate(File.join(Sinatra::Application.root, 'db/migrate'))
  end

  task :seed do
    require_relative File.join(Sinatra::Application.root, 'db/seeds')
  end
end

task :console do
  binding.pry
end
