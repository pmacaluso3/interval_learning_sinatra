task :environment do
  require_relative 'config/environment'
end

task :app do
  require_relative 'app'
end

task :default do
  %w(environment app).each { |task| Rake::Task[task].invoke }
end

namespace :db do
  task create: :default do
    
  end
end
