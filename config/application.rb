require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Apiserver
  class Application < Rails::Application
    
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.time_zone = "Brasilia"
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.available_locales = ['pt-BR']
    config.i18n.default_locale = 'pt-BR'


    #config.i18n.default_locale = 'pt-BR'
    #I18n.enforce_available_locales = false
  config.assets.paths << Rails.root.join("app", "assets", "fonts")
  config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
