# frozen_string_literal: true

require 'dry-validation'

require_relative 'anonymous_message_job'

module Nameless
  # An anonymous message to post within Slack
  class AnonymousMessage
    # The schema for parsing a message from the Slack webhook
    Schema = Dry::Validation.Params do
      configure do
        config.messages_file = File.expand_path('../../config/errors.yml', __dir__)
      end

      required(:text).filled

      optional(:channel_name).filled

      rule(not_a_direct_message: %i[channel_name]) do |channel_name|
        channel_name.filled? > channel_name.not_eql?('directmessage')
      end

      rule(not_a_private_group: %i[channel_name]) do |channel_name|
        channel_name.filled? > channel_name.not_eql?('privategroup')
      end
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
        Null.new(result.messages)
      end
    end

    # Instantiates a new anonymous message
    #
    # @api private
    #
    # @param text [String] the body of the message
    # @param channel_name [String] the channel to post the message to, if any
    def initialize(text:, channel_name: nil)
      self.text = text
      self.channel = channel_name
    end

    # The channel in which the message should appear, if any
    #
    # @api public
    #
    # @example Fetch the channel for the message
    #   message = Nameless::AnonymousMessage.from_params(text: 'Test message', channel_name: 'foo')
    #   message.channel  #=> '#foo'
    #
    # @return [String, nil]
    attr_reader :channel

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
      AnonymousMessageJob.perform_async(self)
    end

    # Converts the message into a Hash that is used with the Slack API
    #
    # @api private
    #
    # @return [Hash]
    def to_h
      {}.tap do |body|
        body[:text] = text if text
        body[:channel] = channel if channel
      end
    end

    # Converts the message into a String for nice error reporting
    #
    # @api private
    #
    # @return [String]
    def to_s
      []
        .tap { |parts| parts << "#{channel}:" if channel }
        .tap { |parts| parts << text if text }
        .join(' ')
    end

    private

    # Sets the text of the message
    #
    # @api private
    #
    # @return [String]
    attr_writer :text

    # Sets the channel for the message
    #
    # @api private
    # @return [String, nil]
    def channel=(value)
      value = "##{value}" if value && !value.start_with?('#')
      @channel = value
    end

    # A null object for handling invalid messages
    #
    # @api private
    class Null < AnonymousMessage
      # Instantiates a new null message
      #
      # @api private
      #
      # @param messages [Hash<Symbol, Array<String>>] the validation messages for errors
      def initialize(messages)
        self.errors = messages.values.flatten
      end

      # The errors that occurred when trying to create the message
      #
      # @api private
      #
      # @return [Array<String>]
      attr_reader :errors

      # Responds to the queue message but does nothing
      #
      # @api private
      #
      # @return [void]
      def queue; end

      private

      # Sets the errors that occurred when trying to create the message
      #
      # @api private
      #
      # @return [Array<String>]
      attr_writer :errors
    end
  end
end
