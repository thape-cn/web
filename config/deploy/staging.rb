# frozen_string_literal: true

set :nginx_use_ssl, true
set :rails_env, "staging"
set :branch, :main
set :puma_service_unit_name, :puma_thape_web
set :puma_systemctl_user, :system

server "bandwagon", user: "thape_web", roles: %w[app db web]
