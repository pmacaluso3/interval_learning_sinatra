load_paths = %w(
  config/initializers/*.rb
  app/controllers/*.rb
)

load_paths.each do |path|
  Dir.glob(path) do |file|
    require File.join(Sinatra::Application.root, file)
  end
end
