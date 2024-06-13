# frozen_string_literal: true

source "https://rubygems.org/"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ">= 3.0"
gem 'ffi', "~> 1.16.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.1.2"
gem "csv"
gem "enumize"
gem "sqlite3", "~> 1.7"
gem "pg"

gem "puma", "~> 6.4" # current thape_web server not ready for puma 6

gem "shakapacker", "~> 8.0"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.11"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "browser", "< 6" # support ruby 3.0

gem "canonical-rails"

gem "sitemap_generator"

# bundle config local.wechat /Users/guochunzhong/git/oss/wechat/
gem "wechat", git: "https://github.com/Eric-Guo/wechat", branch: :main
gem "rake"

group :production do
  gem "dalli"
end

gem "whenever", require: false

group :development, :test do
  gem "standard"
  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem "debug"
end

gem "carrierwave"
gem "carrierwave-aliyun"

gem "globalize"

gem "kaminari"
gem "chinese_pinyin", require: false

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console"
  gem "listen"

  gem "capistrano"
  gem "capistrano-yarn"
  gem "capistrano-rails"
  gem "capistrano-rbenv"
  gem "capistrano3-puma", "~> 6.0.0.beta.1"
  gem "ed25519"
  gem "bcrypt_pbkdf"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.39"
  gem "selenium-webdriver", ">= 4.14.0"
  gem "rexml" # required by selenium-webdriver for ruby 3.0
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
