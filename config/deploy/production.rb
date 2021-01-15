# frozen_string_literal: true

set :nginx_use_ssl, true
set :rails_env, 'production'
set :branch, :main
set :application, 'web'
set :puma_service_unit_name, :puma_thape_web

server 'www.thape.com', user: 'thape_web', roles: %w{app db web}
