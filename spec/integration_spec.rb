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
      post '/webhook', params

      expect(last_response).to be_ok
      expect(last_response.body).to be_empty
    end

    context 'that is missing its text' do
      let(:text) { nil }

      it 'accepts the message and does not post' do
        post '/webhook', params

        expect(last_response).to be_ok
        expect(last_response.body).to be_empty
      end
    end
  end

  context 'for an unauthenticated request' do
    let(:token) { 'this is the wrong token' }

    it 'does not accept the message' do
      post '/webhook', params

      expect(last_response).to be_unauthorized
      expect(last_response.body).to be_empty
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
end
