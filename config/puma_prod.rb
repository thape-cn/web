#!/usr/bin/env puma

directory "/var/www/thape_web/current"
rackup "/var/www/thape_web/current/config.ru"
environment "staging"

tag ""

pidfile "/var/www/thape_web/shared/tmp/pids/puma.pid"
state_path "/var/www/thape_web/shared/tmp/pids/puma.state"
stdout_redirect "/var/www/thape_web/shared/log/puma_access.log", "/var/www/thape_web/shared/log/puma_error.log", true

threads 0, 16

bind "unix:///var/www/thape_web/shared/tmp/sockets/puma.sock"

workers 0

restart_command "bundle exec puma"

prune_bundler

on_restart do
  puts "Refreshing Gemfile"
  ENV["BUNDLE_GEMFILE"] = ""
end
