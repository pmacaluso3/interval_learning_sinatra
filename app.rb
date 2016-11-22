set :root, File.dirname(__FILE__)

load_paths = [
  "config/initializers/*.rb",
  "app/controllers/*.rb"
]

load_paths.each do |path|
  Dir.glob(path) { |file| require_relative file }
end
