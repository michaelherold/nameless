# frozen_string_literal: true

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = %w[Gemfile nameless.gemspec]
  files.each { |file| watch(helper.real_path(file)) }
end

guard :inch do
  watch(/.+\.rb/)
end

guard :rspec, cmd: 'bundle exec rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  rspec = dsl.rspec
  watch(rspec.spec_helper)  { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)
end

guard :rubocop do
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) do |match|
    File.dirname(match.first)
  end
end

guard 'yard' do
  watch(%r{app\/.+\.rb})
  watch(%r{lib\/.+\.rb})
end
