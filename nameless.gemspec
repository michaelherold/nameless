# frozen_string_literal: true

require File.expand_path('lib/nameless/version', __dir__)

Gem::Specification.new do |spec|
  spec.name    = 'nameless'
  spec.version = Nameless::VERSION
  spec.authors = ['Michael Herold']
  spec.email   = ['opensource@michaeljherold.com']

  spec.summary     = 'A simple Slack bot for anonymously posting messages'
  spec.description = spec.summary
  spec.homepage    = 'https://github.com/michaelherold/nameless'
  spec.license     = 'MIT'

  spec.files = %w[README.md CHANGELOG.md nameless.gemspec]
  spec.files += Dir['lib/**/*.rb']
  spec.require_paths = %w[lib]

  spec.add_dependency 'dotenv', '~> 2.4'
  spec.add_dependency 'dry-configurable', '~> 0.11'
  spec.add_dependency 'dry-validation', '~> 1.5'
  spec.add_dependency 'honeybadger', '~> 4.0'
  spec.add_dependency 'http', '~> 4.0'
  spec.add_dependency 'puma', '~> 5.0'
  spec.add_dependency 'roda', '~> 3.8'
  spec.add_dependency 'sucker_punch', '~> 2.0'

  spec.add_development_dependency 'bundler', '>= 1.16'
end
