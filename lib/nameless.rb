# frozen_string_literal: true

require 'pathname'
require 'uri'

require 'dotenv'
require 'dry-configurable'

require_relative 'nameless/version'

# A Slack slash command and incoming webhook for anonymously posting messages.
module Nameless
  extend Dry::Configurable

  # Checks whether the configuration has been bootstrapped
  #
  # @api private
  #
  # @return [Boolean]
  setting :bootstrapped, reader: true

  # The environment in which the application is running
  #
  # @api private
  #
  # @return [String] one of 'development', 'test', or 'production'
  setting :env, reader: true

  # The Slack outgoing token for authenticating requests
  #
  # @api public
  #
  # @example Check the environment we're running in
  #   Nameless.token #=> 'test'
  #
  # @return [String] the token that Slack will attach to call messages
  setting :token, reader: true

  # The root path for referencing files within the application
  #
  # @api private
  #
  # @return [Pathname] the root path in the file system
  setting :root, reader: true

  # The URL of the incoming webhook that will post to Slack
  #
  # @api public
  #
  # @example Get the incoming webhook URL
  #   Nameless.url  #=> URI(...)
  #
  # @return [URI]
  setting :url, reader: true

  # Bootstraps the initial configuration of the application and loads Dotenv
  #
  # @api private
  #
  # @return [void]
  def self.bootstrap
    return if bootstrapped

    config.bootstrapped = true
    config.env          = ENV['RACK_ENV']
    config.root         = Pathname.new(File.expand_path('..', __dir__))

    Dotenv.load(*dotenv_files)
  end

  # Configures the application based on environment variables
  #
  # @api private
  #
  # @return [void]
  def self.configure_from_environment
    bootstrap

    configure do |config|
      config.token = ENV['SLACK_TOKEN']
      config.url   = URI(ENV.fetch('SLACK_WEBHOOK_URL', ''))
    end
  end

  # Resets the configuration to empty for testing purposes
  #
  # @api private
  #
  # @return [void]
  def self.reset
    settings = config.to_h.keys

    settings.each do |setting|
      config.send("#{setting}=", nil)
    end
  end

  # Lists the files that should be loaded by Dotenv
  #
  # @api private
  #
  # @return [Array<Pathname>] the files to load
  private_class_method def self.dotenv_files
    [].tap do |files|
      files << root.join(".env.#{Nameless.env}")
      files << root.join('.env')
    end
  end
end
