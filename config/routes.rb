Rails.application.routes.draw do
  resources :works, only: %i[index show] do
    collection do
      get :residential
      get :"residential-rental"
    end
  end
  root 'home#show'
end
