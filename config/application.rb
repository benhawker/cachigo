require_relative 'boot'

require "action_controller/railtie"

Bundler.require(*Rails.groups)

module Cachigo
  class Application < Rails::Application
    config.load_defaults 5.1
    config.api_only = true
  end
end
