# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gemspec

group :development do
  gem 'guard', require: false
  gem 'guard-bundler', require: false
  gem 'guard-inch', require: false
  gem 'guard-rspec', require: false
  gem 'guard-rubocop', require: false
  gem 'guard-yard', require: false
  gem 'inch', require: false
  gem 'rubocop', require: false
  gem 'yard', require: false
  gem 'yardstick', require: false

  group :test do
    gem 'pry'
    gem 'pry-byebug'
    gem 'rake', '~> 10', require: false
  end
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'rspec'
  gem 'simplecov'
end
