require_relative 'boot'
require 'rails/all'
Bundler.require(*Rails.groups)
Dotenv::Railtie.load unless Rails.env.production?

module Calismamasam
  class Application < Rails::Application
    config.load_defaults 5.1

    config.exceptions_app = self.routes
    config.time_zone = 'Istanbul'
    config.i18n.default_locale = :tr
    config.assets.paths << Rails.root.join("app", "assets")
    config.nav_lynx.selected_class = 'active'
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end
