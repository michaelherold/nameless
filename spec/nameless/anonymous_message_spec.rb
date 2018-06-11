# frozen_string_literal: true

RSpec.describe Nameless::AnonymousMessage do
  describe 'Schema' do
    subject { described_class::Schema }

    it 'has a disaffinity for direct messages' do
      result = subject.call('text' => 'This is a test', 'channel_name' => 'directmessage')

      expect(result).not_to be_a_success
      expect(result.messages).to include(not_a_direct_message: ['You cannot post anonymously in a direct message'])
    end

    it 'has a disaffinity for private groups' do
      result = subject.call('text' => 'This is a test', 'channel_name' => 'privategroup')

      expect(result).not_to be_a_success
      expect(result.messages).to include(not_a_private_group: ['You cannot post anonymously in a private group'])
    end
  end

  describe '.from_params' do
    it 'maps the channel name to the correct parameter' do
      message = described_class.from_params('text' => 'This is a test', 'channel_name' => 'dev-questions')

      expect(message.channel).to eq('#dev-questions')
    end
  end

  describe '#to_h' do
    it 'is empty when there is no text or channel' do
      message = described_class.new(text: nil)

      expect(message.to_h).to eq({})
    end

    it 'is only the text without a channel' do
      message = described_class.new(text: 'Testing')

      expect(message.to_h).to eq(text: 'Testing')
    end

    it 'labels itself with the channel when it has one' do
      message = described_class.new(text: 'Testing', channel_name: 'foo')

      expect(message.to_h).to eq(text: 'Testing', channel: '#foo')
    end
  end

  describe '#to_s' do
    it 'is empty when there is no text or channel' do
      message = described_class.new(text: nil)

      expect(message.to_s).to eq('')
    end

    it 'is only the text without a channel' do
      message = described_class.new(text: 'Testing')

      expect(message.to_s).to eq('Testing')
    end

    it 'labels itself with the channel when it has one' do
      message = described_class.new(text: 'Testing', channel_name: 'foo')

      expect(message.to_s).to eq('#foo: Testing')
    end
  end
end
