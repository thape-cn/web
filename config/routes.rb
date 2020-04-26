Rails.application.routes.draw do
  resource :works, only: %i[show] do
    resource :residential, only: %i[show] do
      get :rental
    end
  end
  root 'home#show'
end
