require_relative 'config/environment'

require 'sass/plugin/rack'
Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

set :root, File.dirname(__FILE__)
set :app_name, :interval_learning
enable :sessions

require_relative 'config/loader'

Sinatra::Application.run! if $0 == __FILE__
