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

  task :clear do
    [User, Deck, Card, Game, Guess].each do |klass|
      klass.destroy_all
    end
  end
end

task :console do
  binding.pry
end

desc 'Set all guesses for a game to 0 times_correct. Pass in game_id as arg.'
task :reset_game do
  # this keeps rake from failing when running the number as a task
  ARGV.each { |arg| task arg.to_sym do ; end }

  game_to_reset = Game.find(ARGV[1])
  game_to_reset.guesses.each do |guess|
    guess.times_correct = 0
    guess.repeat_at = Time.now
    guess.save
  end
end
