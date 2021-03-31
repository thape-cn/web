# frozen_string_literal: true
set :rbenv_ruby, '2.7.2'
set :nginx_use_ssl, true
set :rails_env, 'staging'
set :branch, :publication
set :puma_service_unit_name, :puma_thape_web

server 'bandwagon', user: 'thape_web', roles: %w{app db web}
