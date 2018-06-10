# frozen_string_literal: true

require 'dry-validation'

module Nameless
  # An anonymous message to post within Slack
  class AnonymousMessage
    # The schema for parsing a message from the Slack webhook
    Schema = Dry::Validation.Params do
      required(:text).filled
    end

    # Create an anonymous message from the params to the webhook
    #
    # @api public
    #
    # @example Construct a message from some parameters
    #   message = Nameless::AnonymousMessage.from_params(text: 'Test message')
    #   message.text  #=> 'Test message'
    #
    # @example Construct a null message for missing parameters
    #   message = Nameless::AnonymousMessage.from_params(text: '')
    #   message.text  #=> nil
    #
    # @param params [Hash] the parameters from the webhook notification
    # @option params [String] :text the body of the anonymous message
    #
    # @return [Nameless::AnonymousMessage]
    def self.from_params(params)
      result = Schema.call(params)

      if result.success?
        new(result.output)
      else
        Null.new
      end
    end

    # Instantiates a new anonymous message
    #
    # @api private
    #
    # @param text [String] the body of the message
    def initialize(text:)
      self.text = text
    end

    # Queues the message for sending in the background
    #
    # @api public
    #
    # @example Send a new anonymous message
    #   message = Nameless::AnonymousMessage.from_params(text: 'Test message')
    #   message.queue
    #
    # @return [void]
    def queue
      nil
    end

    # The body of the message
    #
    # @api public
    #
    # @example Fetch the body of the message to send
    #   message = Nameless::AnonymousMessage.from_params(text: 'Test message')
    #   message.text  #=> 'Test message'
    #
    # @return [String]
    attr_reader :text

    private

    # Sets the text of the message
    #
    # @api private
    #
    # @return [String]
    attr_writer :text

    # A null object for handling invalid messages
    #
    # @api private
    class Null < AnonymousMessage
      # Instantiates a new null message
      #
      # @api private
      def initialize(*); end

      # Responds to the queue message but does nothing
      #
      # @api private
      #
      # @return [void]
      def queue; end
    end
  end
end
