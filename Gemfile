# frozen_string_literal: true

source "https://rubygems.org/"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ">= 3.0"
gem 'ffi', "~> 1.16.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.1.2"
gem "io-console", "~> 0.7.2"
gem "nokogiri", "~> 1.18.2"
gem "net-imap", "~> 0.4.17"
gem "securerandom", "~> 0.3.2"
gem "reline", "~> 0.5.12"
gem "unicode-display_width", "~> 2.6"
gem "csv"
gem "enumize"
gem "sqlite3"
gem "pg"

gem "puma", "~> 6.4" # current thape_web server not ready for puma 6

gem "shakapacker", "~> 8.2"
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

# bundle config local.wechat /Users/$(whoami)/git/oss/wechat/
gem "wechat", git: "https://git.thape.com.cn/Eric-Guo/wechat.git", branch: :main
gem "rake"

# bundle config local.ruby_llm /Users/$(whoami)/git/oss/ruby_llm/
gem "ruby_llm", git: "https://git.thape.com.cn/rails/ruby_llm.git", branch: :WithResponseFormat2
gem "uri"
gem "faraday-net_http"
gem "net-http", "~> 0.4.1"

group :production do
  gem "dalli"
  gem "rorvswild"
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

  # Support cursor / vs code
  gem "ruby-lsp", require: false
  gem "ruby-lsp-rails", require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.39"
  gem "selenium-webdriver", "= 4.26.0"
  gem "rexml" # required by selenium-webdriver for ruby 3.0
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
