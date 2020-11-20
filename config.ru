# frozen_string_literal: true

require_relative 'lib/nameless'

Nameless.configure_from_environment

require_relative 'lib/nameless/app'

run Nameless::App.freeze.app
