Rails.application.routes.draw do
  resource :works, only: %i[show]
  root 'home#show'
end
