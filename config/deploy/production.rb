set :nginx_use_ssl, true
set :rails_env, 'production'
set :branch, :main
set :application, 'web'

server 'www.thape.com', user: 'thape_web', roles: %w{app db web}
