require_relative "boot"

require "rails/all"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OauthIdpApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.hosts << "idp.myapp.local"
    config.hosts << "accounts.lalit.local"
    config.hosts << "host.docker.internal:3000"
    config.hosts << "oauth-idp-service"
    config.hosts << "oauth-idp-app-service"

    # config.log_formatter = ::Logger::Formatter.new
    # config.logger = ActiveSupport::Logger.new($stdout)
    # config.logger.formatter = proc do |severity, timestamp, progname, msg|
    #   JSON.dump({
    #     severity: severity,
    #     time: timestamp.utc.iso8601,
    #     progname: progname,
    #     message: msg
    #   }) + "\n"
    # end
  end
end
