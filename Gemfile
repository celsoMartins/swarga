source 'https://rubygems.org'

ruby '2.4.3'

gem 'rails', '5.1.4'
gem 'uglifier'
gem 'therubyracer', platforms: :ruby
gem 'coffee-rails'
gem 'jquery-rails'
gem 'yui-compressor'

gem 'devise'

gem 'pg'

gem 'figaro'

gem 'httparty'

gem 'sidekiq'

group :test, :development do
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'faker'
  gem 'rubocop'
  gem 'simplecov', '0.15.1', require: false
  gem 'codeclimate-test-reporter'
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
