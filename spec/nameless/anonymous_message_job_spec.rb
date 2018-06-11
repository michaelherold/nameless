# frozen_string_literal: true

RSpec.describe Nameless::AnonymousMessageJob do
  describe '#perform' do
    let(:message) { Nameless::AnonymousMessage.new(text: 'Testing') }

    context 'when the request succeeds' do
      before { stub_success }

      it 'only makes the request once' do
        described_class.new.perform(message)

        expect(a_slack_request).to have_been_made.once
      end
    end

    context 'when the request fails' do
      before { stub_failure }

      it 'tries up to five times' do
        expect { described_class.new.perform(message) }.to raise_error(Nameless::AnonymousMessageJob::ClientError, 'Bad token')

        expect(a_slack_request).to have_been_made.once
      end
    end

    context 'when the request times out' do
      before { stub_timeout }

      it 'tries up to five times' do
        expect { described_class.new.perform(message) }.to raise_error(Nameless::AnonymousMessageJob::UnableToPostMessage, 'Testing')

        expect(a_slack_request).to have_been_made.times(5)
      end
    end
  end

  def a_slack_request
    a_request(:post, 'https://example.com/webhook')
  end

  def stub_slack_post(status:, body:, headers: {})
    stub_request(:post, 'https://example.com/webhook')
      .to_return(status: status, body: body, headers: headers)
  end

  def stub_success
    stub_slack_post(status: 200, body: 'ok')
  end

  def stub_failure
    stub_slack_post(status: 404, body: 'Bad token')
  end

  def stub_timeout
    stub_request(:post, 'https://example.com/webhook')
      .to_timeout
  end
end
