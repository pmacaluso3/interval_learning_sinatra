# %w(development test production).each do |env|
#   configure env do
#     set :database, {
#       adapter: 'postgresql',
#       encoding: 'utf8',
#       database: env,
#       pool: 2,
#       username: Sinatra::Application.app_name,
#       password: Sinatra::Application.app_name
#     }  
#   end
# end

# The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
configure :production, :development do
  app_name = Sinatra::Application.app_name
  default_db_url = "postgres://localhost/#{app_name}_#{Sinatra::Application.environment}"
  db = URI.parse(ENV['DATABASE_URL'] || default_db_url)
  ActiveRecord::Base.establish_connection(
      :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :port     => db.port,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
  )
end

