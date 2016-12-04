require 'sinatra'
require 'active_record'
require 'haml'
require 'rake'
require 'bcrypt'
require 'sass'

# TODO: how do I set RACK_ENV for a single command like in rails?
if [:development, :test].include? Sinatra::Application.environment
  require 'pry'
  require 'shotgun'
end

