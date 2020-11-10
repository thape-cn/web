set :nginx_use_ssl, true
set :rails_env, 'staging'
set :branch, :main

server 'bandwagon', user: 'thape_web', roles: %w{app db web}
