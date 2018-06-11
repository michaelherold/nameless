# frozen_string_literal: true

require 'forwardable'

require 'http'
require 'sucker_punch'

module Nameless
  # Posts an anonymous message to Slack
  class AnonymousMessageJob
    extend Forwardable
    include SuckerPunch::Job

    # Raised when we have an error in our posting
    ClientError = Class.new(StandardError)

    # Raised when the job cannot post a message after several tries
    UnableToPostMessage = Class.new(StandardError)

    # Sends the anonymous message to Slack
    #
    # @api public
    #
    # @example Posts a message to Slack
    #   message = Nameless::AnonymousMessage.new(text: 'Testing')
    #   Nameless::AnonymousMessageJob.perform_async(message)
    #
    # @param message [AnonymousMessage] the message to post to Slack
    # @param tries [Integer] the number of tries left for posting the message
    # @return [void]
    # @raise [UnableToPostMessage] if the message doesn't post after several tries
    def perform(message, tries = 5)
      response =
        HTTP
        .timeout(:global, connect: 5, read: 10, write: 2)
        .post(url, json: message.to_h)

      raise ClientError, response.body.to_s unless response.body.to_s == 'ok'
    rescue HTTP::TimeoutError
      tries -= 1
      raise UnableToPostMessage, message.to_s if tries.zero?
      retry
    end

    # The URL to which we are sending the message
    #
    # @api private
    #
    # @return [URI]
    private def_delegator :Nameless, :url # rubocop:disable Style/AccessModifierDeclarations
  end
end
