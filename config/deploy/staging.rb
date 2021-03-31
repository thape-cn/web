# frozen_string_literal: true

set :nginx_use_ssl, true
set :rails_env, 'publication'
set :branch, :main
set :puma_service_unit_name, :puma_thape_web

server 'bandwagon', user: 'thape_web', roles: %w{app db web}
