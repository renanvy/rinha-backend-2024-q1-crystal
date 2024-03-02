require "json"
require "kemal"
require "../config/initializers/**"
require "./models/*"
require "./services/*"
require "./routes/*"

module Server
  I18n.load_path += ["#{__DIR__}/locales/**/*.yml"]
  I18n.init

  VERSION = "0.1.0"
  Kemal.config.logging = false

  Kemal.run 3000
end
