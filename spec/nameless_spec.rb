# frozen_string_literal: true

RSpec.describe Nameless do
  it 'has a version number' do
    expect(Nameless::VERSION).not_to be nil
  end

  describe 'configuration management' do
    around(:each) do |example|
      described_class.reset
      example.run
      described_class.bootstrap
      described_class.configure_from_environment
    end

    describe '.bootstrap' do
      subject { described_class.bootstrap }

      it 'does not load Dotenv if it has previously been bootstrapped' do
        expect(Dotenv).not_to receive(:load)

        described_class.config.bootstrapped = true

        subject
      end
    end

    describe '.config_from_environment' do
      before { described_class.bootstrap }

      subject { described_class.configure_from_environment }

      it 'reads the configuration from Dotenv-loaded environment variables' do
        expect { subject }.to(
          change(Nameless, :token).from(nil).to('this is the correct token')
            .and(change(Nameless, :url).from(nil).to(URI('https://example.com/webhook')))
        )
      end
    end
  end
end
