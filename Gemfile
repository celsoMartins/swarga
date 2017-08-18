source 'https://rubygems.org'

ruby '2.4.0'

gem 'rails', '5.0.3'
gem 'uglifier'
gem 'therubyracer', platforms: :ruby
gem 'coffee-rails'
gem 'jquery-rails'
gem 'yui-compressor'

gem 'devise'

gem 'pg'
gem 'pg_search'

gem 'figaro'

gem 'httparty'

gem 'money-rails', git: 'https://github.com/RubyMoney/money-rails'

gem 'sidekiq'

group :test, :development do
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'faker'
  gem 'rubocop', git: 'git@github.com:bbatsov/rubocop.git', branch: 'master'
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'parser'
  gem 'brakeman'
end

group :development do
  gem 'web-console'
  gem 'annotate'
end

group :test do
  gem 'rspec_junit_formatter'
  gem 'rails-controller-testing'
end

group :production do
  gem 'rails_12factor'
  gem 'puma'
end
