Rails.application.routes.draw do
  resource :works, only: %i[show] do
    get :residential
  end
  root 'home#show'
end
