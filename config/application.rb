require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RubyRain
  class Application < Rails::Application
    config.current_tournament_index = 27 # go down by 1 each week

    config.web_console.whitelisted_ips = '96.247.194.41' # to access console -- strictly for development
  end
end
