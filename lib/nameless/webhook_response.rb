# frozen_string_literal: true

module Nameless
  # Formats and outputs any response that is neccessary to a Slack webhook
  class WebhookResponse
    # Creates a new response form a message
    #
    # @api public
    #
    # @example Render an empty response for a successful message
    #   message = Nameless::AnonymousMessage.from_params(text: 'This is a test')
    #   Nameless::WebhookResponse.from(message)  #=> ''
    #
    # @param message [AnonymousMessage] the message to respond to
    # @return [String] the body of the response
    def self.from(message)
      case message
      when Nameless::AnonymousMessage::Null then new(message).to_s
      else ''
      end
    end

    # Instantiates a new response
    #
    # @api private
    #
    # @param message [AnonymousMessage] the message to respond to
    def initialize(message)
      self.errors = message.errors
    end

    # Outputs the body of the response
    #
    # @api private
    #
    # @return [String]
    def to_s
      JSON.dump(to_h)
    end

    # Outputs the body of the response as a JSONifiable hash
    #
    # @api private
    #
    # @return [Hash]
    def to_h
      {
        response_type: 'ephemeral',
        text: 'Sorry, I could not send your message',
        attachments: errors.flat_map { |message| { text: message } }
      }
    end

    private

    # The list of errors to call out in the response
    #
    # @api private
    #
    # @return [Array<String>]
    attr_accessor :errors
  end
end
