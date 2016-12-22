require 'sinatra'
require 'active_record'
require 'haml'
require 'rake'
require 'bcrypt'
require 'sass'

# required in prod to run console task
require 'pry'

if [:development, :test].include? Sinatra::Application.environment
  # use `rackup config.ru` in prod
  require 'shotgun'
end

