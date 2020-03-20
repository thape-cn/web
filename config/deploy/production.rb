set :nginx_use_ssl, false

server 'bandwagon', user: 'thape_web', roles: %w{app db web}
