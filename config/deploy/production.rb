set :nginx_use_ssl, true

server 'bandwagon', user: 'thape_web', roles: %w{app db web}
