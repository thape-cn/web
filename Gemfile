# frozen_string_literal: true

source 'https://rubygems.org/'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '>= 2.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.1'
gem 'enumize'
gem 'sqlite3'
gem 'pg'

# Use Puma as the app server
gem 'puma'
gem 'shakapacker'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.9.3', require: false

gem 'browser'

gem 'canonical-rails'

gem 'sitemap_generator'

# bundle config local.wechat /Users/guochunzhong/git/oss/wechat/
gem 'wechat', git: 'https://github.com/Eric-Guo/wechat', branch: :main
gem 'rake'

group :production do
  gem 'dalli'
end

gem 'whenever', require: false

group :development, :test do
  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem 'debug'
end

gem 'carrierwave'
gem 'carrierwave-aliyun'

# bundle config local.globalize /Users/guochunzhong/git/oss/globalize/
gem 'globalize', git: 'https://github.com/ekampp/globalize', branch: 'patch-1'

gem 'kaminari'
gem 'chinese_pinyin', require: false

group :development do
  gem 'localhost', require: 'localhost/authority' # supports puma for self-signed certificates.

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen'

  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano3-puma'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'rexml' # required by selenium-webdriver for ruby 3.0

  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
