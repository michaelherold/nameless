# frozen_string_literal: true

RSpec.describe 'the Nameless application', type: :integration do
  # :reek:UtilityFunction
  def app
    Nameless::App.freeze.app
  end

  let(:text) { 'Hello, world. I am testing the nameless bot' }

  context 'for an authenticated request' do
    let(:token) { Nameless.token }

    it 'accepts the message and posts' do
      stub_success

      post '/webhook', params

      expect(last_response).to be_ok
      expect(last_response.body).to be_empty
      expect(a_request(:post, 'https://example.com/webhook')).to have_been_made
    end

    context 'that is missing its text' do
      let(:text) { nil }

      it 'accepts the message and does not post' do
        post '/webhook', params

        expect(last_response).to be_ok

        parsed_body = JSON.parse(last_response.body, symbolize_names: true)
        expect(parsed_body).to include(response_type: 'ephemeral')
        expect(parsed_body).to have_key(:text)
        expect(parsed_body).to have_key(:attachments)
        expect(a_request(:post, 'https://example.com/webhook')).not_to have_been_made
      end
    end
  end

  context 'for an unauthenticated request' do
    let(:token) { 'this is the wrong token' }

    it 'does not accept the message' do
      post '/webhook', params

      expect(last_response).to be_unauthorized
      expect(last_response.body).to be_empty
      expect(a_request(:post, 'https://example.com/webhook')).not_to have_been_made
    end
  end

  def params
    {
      channel_id: 'C1234',
      channel_name: 'testing',
      text: text,
      token: token
    }
  end

  def stub_slack_post(status:, body:, headers: {})
    stub_request(:post, 'https://example.com/webhook')
      .to_return(status: status, body: body, headers: headers)
  end

  def stub_success
    stub_slack_post(status: 200, body: 'ok')
  end
end
