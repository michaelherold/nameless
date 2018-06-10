# frozen_string_literal: true

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'

  SimpleCov.start
end

ENV['RACK_ENV'] = 'test'

require 'bundler/setup'
require 'nameless'
require 'pry'
require 'rack/test'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.default_formatter = 'doc' if config.files_to_run.one?
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = '.rspec_status'
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.profile_examples = 10 if ENV['PROFILE']

  config.include Rack::Test::Methods, type: :integration

  config.order = :random
  Kernel.srand config.seed
end
