source "https://rubygems.org"

gem "devise"
gem "htmlentities"
gem "nokogiri"
gem "omniauth"
gem "omniauth-twitter"
gem "twitter"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.0"
# Use sqlite3 as the database for Active Record
gem "sqlite3"
# Use SCSS for stylesheets
gem "sassc-rails"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
gem "therubyracer", platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"

# Use Unicorn as the app server
gem "unicorn"


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"

  # Use Capistrano for deployment
  gem "capistrano-chruby"
  gem "capistrano-rails"
  gem "capistrano3-unicorn"
  gem "ed25519", "< 2.0"
  gem "bcrypt_pbkdf", "< 2.0"
end

group :test do
  gem "webmock"

  # TODO(oliver): Update to Rails 5 style tests.
  gem "rails-controller-testing"
end
