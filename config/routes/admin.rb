# frozen_string_literal: true

namespace :admin do
  concern :orderable do
    patch :reorder, on: :member
  end
  root "dashboard#show", as: "root"
  resource :tail_home, only: [:edit, :update]
  resource :about_page, only: [:edit, :update]
  resource :work_type_page, only: [:edit, :update]
  resources :people, concerns: :orderable do
    member do
      delete :destory_city_people
    end
  end
  resources :seos, only: [:index, :update]
  resources :cities, except: [:destroy, :show]
  resources :map_contacts, only: [:index, :edit, :update]
  resources :users, except: [:show, :edit, :update]
  resources :service_files, only: [:show, :edit, :update]
  resources :cases, concerns: :orderable do
    member do
      delete :destory_picture
    end
  end
  resources :works, concerns: :orderable do
    member do
      delete :destory_picture
    end
  end
  resources :infos, concerns: :orderable
  resources :pictures, except: [:show] do
    post :upload, on: :collection
  end
  resources :message, only: [:index, :show, :destroy]
  resources :project_messages, only: [:index, :show, :destroy]
  resources :portfolios, except: [:show], concerns: :orderable
  resources :publications, except: [:show], concerns: :orderable
  resources :insights, except: [:show], concerns: :orderable
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
