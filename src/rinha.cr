require "json"
require "kemal"
require "../config/initializers/**"
require "./models/*"
require "./services/*"
require "./routes/*"

module Server
  ENV["PORT"] ||= "3000"

  I18n.load_path += ["#{__DIR__}/locales/**/*.yml"]
  I18n.init
  I18n.default_locale = "en"

  VERSION = "0.1.0"
  port = ENV["PORT"].to_i
  Kemal.config.logging = false
  Kemal.run port
end
