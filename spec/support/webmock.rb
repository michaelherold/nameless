# frozen_string_literal: true

require 'webmock/rspec'

WebMock.enable!

RSpec.configure do |config|
  config.include WebMock::API
end
