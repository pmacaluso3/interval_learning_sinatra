require_relative 'environment'

#require app/controllers
Dir.glob("app/controllers/*.rb") { |file| require_relative file }
