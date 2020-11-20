# Nameless

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Do you have a team with junior people on it? This app might be for you.

A simple Slack app that allows you to post anonymous messages to your Slack. The intended purpose is to allow people to ask questions anonymously when they would otherwise feel embarrassed asking the question.

**Note:** There is no protection against abuse by people from within your team (e.g. rate limiting, logging who said what, or anything else). If your team does not have a level of trust where you feel comfortable about it not being abused, perhaps look for another solution. Have ideas of how to do this in a lightweight way? Please feel free to contribute!

## Installation

There are two ways to run this application: as a standalone app or mounted
within a larger app (like a Rails application).

### Standalone

Use the "Deploy to Heroku" button above to deploy the application on Heroku's
free tier.

If you would like to run it manually, clone this repository:

    $ git clone https://github.com/michaelherold/nameless.git

And then execute:

    $ bundle

### Mounted in another application

Add this line to your application's Gemfile:

```ruby
gem 'nameless', git: 'https://github.com/michaelherold/nameless'
```

And then execute:

    $ bundle

## Usage

Within your Slack team, you will have to create two custom integrations:

1. A "Slash Command" for sending messages to the application
2. An "Incoming WebHook" for posting anonymous message back to Slack

When configuring the Slash Command, pay attention to the "token" value because you will need to set that as your `SLACK_TOKEN` environment variable for authenticating messages to the application.

Similarly, when configuring the Incoming WebHook, note the URL of the webhook because you will need to set that as your `SLACK_WEBHOOK_URL` environment variable to tell Nameless how to talk to Slack.

### Running as a standalone app

Starting the application in standalone mode is as simple as running the `rackup` command. When running locally, you can create a `.env.<environment>` file with your environment variables. However, we recommend using a process manager like Systemd to manage your environment variables more securely.

### Mounting inside another application

Because Nameless is a simple Rack application, you can mount it within other Rack applications, such as a Rails application.

#### Rails

In your `config/routes.rb` file, mount the application:

```ruby
Rails.application.routes.draw do
  require 'nameless/app'
  mount Nameless::App.freeze.app, at: '/nameless'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/michaelherold/nameless.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
