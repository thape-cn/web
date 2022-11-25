# frozen_string_literal: true

set :rbenv_ruby, "3.1.3"
set :nginx_use_ssl, true
set :rails_env, "production"
set :branch, :main
set :application, "web"
set :puma_service_unit_name, :puma_thape_web
set :puma_systemctl_user, :system

server "thape_web", user: "thape_web", roles: %w[app db web]
