require "json"
require "kemal"
require "../config/initializers/**"
require "./models/*"
require "./routes/*"

module Server
  ENV["PORT"] ||= "3000"

  VERSION = "0.1.0"
  port = ENV["PORT"].to_i
  # Kemal.config.logging = false
  Kemal.run port
end
