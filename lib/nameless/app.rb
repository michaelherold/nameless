# frozen_string_literal: true

require 'honeybadger'
require 'roda'

require_relative 'anonymous_message'
require_relative 'webhook_response'

module Nameless
  # The web application for handling Slack slash commands
  class App < Roda
    plugin :default_headers, 'Content-Type' => 'application/json'
    plugin :json
    plugin :symbol_status

    use Rack::CommonLogger, Nameless.logger
    use Honeybadger::Rack::ErrorNotifier

    route do |route|
      route.is 'webhook' do
        route.post do
          if route.params['token'] == Nameless.token
            message = Nameless::AnonymousMessage.from_params(route.params)
            message.queue

            Nameless::WebhookResponse.from(message)
          else
            response.status = :unauthorized
            ''
          end
        end
      end
    end
  end
end
